# Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#import "FWFInstanceManager.h"
#import "FWFInstanceManager_Test.h"

#import <objc/runtime.h>

// Attaches to an object to receive a callback when the object is deallocated.
@interface FWFFinalizer : NSObject
@end

// Attaches to an object to receive a callback when the object is deallocated.
@implementation FWFFinalizer {
  long _identifier;
  // Callbacks are no longer made once FWFInstanceManager is inaccessible.
  FWFOnDeallocCallback __weak _callback;
}

- (instancetype)initWithIdentifier:(long)identifier callback:(FWFOnDeallocCallback)callback {
  self = [self init];
  if (self) {
    _identifier = identifier;
    _callback = callback;
  }
  return self;
}

+ (void)attachToInstance:(NSObject *)instance
          withIdentifier:(long)identifier
                callback:(FWFOnDeallocCallback)callback {
  FWFFinalizer *finalizer = [[FWFFinalizer alloc] initWithIdentifier:identifier callback:callback];
  objc_setAssociatedObject(instance, _cmd, finalizer, OBJC_ASSOCIATION_RETAIN);
}

+ (void)detachFromInstance:(NSObject *)instance {
  objc_setAssociatedObject(instance, @selector(attachToInstance:withIdentifier:callback:), nil,
                           OBJC_ASSOCIATION_ASSIGN);
}

- (void)dealloc {
  if (_callback) {
    _callback(_identifier);
  }
}
@end

@interface FWFInstanceManager ()
@property dispatch_queue_t lockQueue;
@property NSMapTable<NSObject *, NSNumber *> *identifiers;
@property NSMapTable<NSNumber *, NSObject *> *weakInstances;
@property NSMapTable<NSNumber *, NSObject *> *strongInstances;
@end

@implementation FWFInstanceManager
// Identifiers are locked to a specific range to avoid collisions with objects
// created simultaneously from Dart.
// Host uses identifiers >= 2^16 and Dart is expected to use values n where,
// 0 <= n < 2^16.
static long const FWFMinHostCreatedIdentifier = 65536;

- (instancetype)init {
  self = [super init];
  if (self) {
    _deallocCallback = _deallocCallback ? _deallocCallback : ^(long identifier) {
    };
    _lockQueue = dispatch_queue_create("FWFInstanceManager", DISPATCH_QUEUE_SERIAL);
    // Pointer equality is used to prevent collisions of objects that override the `isEqualTo:`
    // method.
    _identifiers =
        [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory | NSMapTableObjectPointerPersonality
                              valueOptions:NSMapTableStrongMemory];
    _weakInstances = [NSMapTable
        mapTableWithKeyOptions:NSMapTableStrongMemory
                  valueOptions:NSMapTableWeakMemory | NSMapTableObjectPointerPersonality];
    _strongInstances = [NSMapTable
        mapTableWithKeyOptions:NSMapTableStrongMemory
                  valueOptions:NSMapTableStrongMemory | NSMapTableObjectPointerPersonality];
    _nextIdentifier = FWFMinHostCreatedIdentifier;
  }
  return self;
}

- (instancetype)initWithDeallocCallback:(FWFOnDeallocCallback)callback {
  self = [self init];
  if (self) {
    _deallocCallback = callback;
  }
  return self;
}

- (void)addDartCreatedInstance:(NSObject *)instance withIdentifier:(long)instanceIdentifier {
  NSParameterAssert(instance);
  NSParameterAssert(instanceIdentifier >= 0);
  dispatch_async(_lockQueue, ^{
    [self addInstance:instance withIdentifier:instanceIdentifier];
  });
}

- (long)addHostCreatedInstance:(nonnull NSObject *)instance {
  NSParameterAssert(instance);
  long __block identifier = -1;
  dispatch_sync(_lockQueue, ^{
    identifier = self.nextIdentifier++;
    [self addInstance:instance withIdentifier:identifier];
  });
  return identifier;
}

- (nullable NSObject *)removeInstanceWithIdentifier:(long)instanceIdentifier {
  NSObject *__block instance = nil;
  dispatch_sync(_lockQueue, ^{
    instance = [self.strongInstances objectForKey:@(instanceIdentifier)];
    if (instance) {
      [self.strongInstances removeObjectForKey:@(instanceIdentifier)];
    }
  });
  return instance;
}

- (nullable NSObject *)instanceForIdentifier:(long)instanceIdentifier {
  NSObject *__block instance = nil;
  dispatch_sync(_lockQueue, ^{
    instance = [self.weakInstances objectForKey:@(instanceIdentifier)];
  });
  return instance;
}

- (void)addInstance:(nonnull NSObject *)instance withIdentifier:(long)instanceIdentifier {
  [self.identifiers setObject:@(instanceIdentifier) forKey:instance];
  [self.weakInstances setObject:instance forKey:@(instanceIdentifier)];
  [self.strongInstances setObject:instance forKey:@(instanceIdentifier)];
  [FWFFinalizer attachToInstance:instance
                  withIdentifier:instanceIdentifier
                        callback:self.deallocCallback];
}

- (long)identifierWithStrongReferenceForInstance:(nonnull NSObject *)instance {
  NSNumber *__block identifierNumber = nil;
  dispatch_sync(_lockQueue, ^{
    identifierNumber = [self.identifiers objectForKey:instance];
    if (identifierNumber) {
      [self.strongInstances setObject:instance forKey:identifierNumber];
    }
  });
  return identifierNumber ? identifierNumber.longValue : NSNotFound;
}

- (BOOL)containsInstance:(nonnull NSObject *)instance {
  BOOL __block containsInstance;
  dispatch_sync(_lockQueue, ^{
    containsInstance = [self.identifiers objectForKey:instance];
  });
  return containsInstance;
}

- (NSUInteger)strongInstanceCount {
  NSUInteger __block count = -1;
  dispatch_sync(_lockQueue, ^{
    count = self.strongInstances.count;
  });
  return count;
}

- (NSUInteger)weakInstanceCount {
  NSUInteger __block count = -1;
  dispatch_sync(_lockQueue, ^{
    count = self.weakInstances.count;
  });
  return count;
}
@end
