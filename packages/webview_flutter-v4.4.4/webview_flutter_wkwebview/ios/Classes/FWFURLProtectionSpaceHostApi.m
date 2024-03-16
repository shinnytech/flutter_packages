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

#import "FWFURLProtectionSpaceHostApi.h"

@interface FWFURLProtectionSpaceFlutterApiImpl ()
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFURLProtectionSpaceFlutterApiImpl
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager {
  self = [self init];
  if (self) {
    _instanceManager = instanceManager;
    _api = [[FWFNSUrlProtectionSpaceFlutterApi alloc] initWithBinaryMessenger:binaryMessenger];
  }
  return self;
}

- (void)createWithInstance:(NSURLProtectionSpace *)instance
                      host:(nullable NSString *)host
                     realm:(nullable NSString *)realm
      authenticationMethod:(nullable NSString *)authenticationMethod
                completion:(void (^)(FlutterError *_Nullable))completion {
  if (![self.instanceManager containsInstance:instance]) {
    [self.api createWithIdentifier:[self.instanceManager addHostCreatedInstance:instance]
                              host:host
                             realm:realm
              authenticationMethod:authenticationMethod
                        completion:completion];
  }
}
@end
