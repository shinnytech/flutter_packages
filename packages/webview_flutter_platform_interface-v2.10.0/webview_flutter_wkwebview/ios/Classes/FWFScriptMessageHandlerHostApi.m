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

#import "FWFScriptMessageHandlerHostApi.h"
#import "FWFDataConverters.h"

@interface FWFScriptMessageHandlerFlutterApiImpl ()
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFScriptMessageHandlerFlutterApiImpl
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager {
  self = [self initWithBinaryMessenger:binaryMessenger];
  if (self) {
    _instanceManager = instanceManager;
  }
  return self;
}

- (long)identifierForHandler:(FWFScriptMessageHandler *)instance {
  return [self.instanceManager identifierWithStrongReferenceForInstance:instance];
}

- (void)didReceiveScriptMessageForHandler:(FWFScriptMessageHandler *)instance
                    userContentController:(WKUserContentController *)userContentController
                                  message:(WKScriptMessage *)message
                               completion:(void (^)(FlutterError *_Nullable))completion {
  NSInteger userContentControllerIdentifier =
      [self.instanceManager identifierWithStrongReferenceForInstance:userContentController];
  FWFWKScriptMessageData *messageData = FWFWKScriptMessageDataFromNativeWKScriptMessage(message);
  [self didReceiveScriptMessageForHandlerWithIdentifier:[self identifierForHandler:instance]
                        userContentControllerIdentifier:userContentControllerIdentifier
                                                message:messageData
                                             completion:completion];
}
@end

@implementation FWFScriptMessageHandler
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager {
  self = [super initWithBinaryMessenger:binaryMessenger instanceManager:instanceManager];
  if (self) {
    _scriptMessageHandlerAPI =
        [[FWFScriptMessageHandlerFlutterApiImpl alloc] initWithBinaryMessenger:binaryMessenger
                                                               instanceManager:instanceManager];
  }
  return self;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController
      didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
  [self.scriptMessageHandlerAPI didReceiveScriptMessageForHandler:self
                                            userContentController:userContentController
                                                          message:message
                                                       completion:^(FlutterError *error) {
                                                         NSAssert(!error, @"%@", error);
                                                       }];
}
@end

@interface FWFScriptMessageHandlerHostApiImpl ()
// BinaryMessenger must be weak to prevent a circular reference with the host API it
// references.
@property(nonatomic, weak) id<FlutterBinaryMessenger> binaryMessenger;
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFScriptMessageHandlerHostApiImpl
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager {
  self = [self init];
  if (self) {
    _binaryMessenger = binaryMessenger;
    _instanceManager = instanceManager;
  }
  return self;
}

- (FWFScriptMessageHandler *)scriptMessageHandlerForIdentifier:(NSNumber *)identifier {
  return (FWFScriptMessageHandler *)[self.instanceManager
      instanceForIdentifier:identifier.longValue];
}

- (void)createWithIdentifier:(NSInteger)identifier error:(FlutterError *_Nullable *_Nonnull)error {
  FWFScriptMessageHandler *scriptMessageHandler =
      [[FWFScriptMessageHandler alloc] initWithBinaryMessenger:self.binaryMessenger
                                               instanceManager:self.instanceManager];
  [self.instanceManager addDartCreatedInstance:scriptMessageHandler withIdentifier:identifier];
}
@end
