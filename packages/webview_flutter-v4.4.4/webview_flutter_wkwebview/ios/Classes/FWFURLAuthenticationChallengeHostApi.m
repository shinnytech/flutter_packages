/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FWFURLAuthenticationChallengeHostApi.h"
#import "FWFURLProtectionSpaceHostApi.h"

@interface FWFURLAuthenticationChallengeFlutterApiImpl ()
// BinaryMessenger must be weak to prevent a circular reference with the host API it
// references.
@property(nonatomic, weak) id<FlutterBinaryMessenger> binaryMessenger;
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFURLAuthenticationChallengeFlutterApiImpl
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager {
  self = [self init];
  if (self) {
    _binaryMessenger = binaryMessenger;
    _instanceManager = instanceManager;
    _api =
        [[FWFNSUrlAuthenticationChallengeFlutterApi alloc] initWithBinaryMessenger:binaryMessenger];
  }
  return self;
}

- (void)createWithInstance:(NSURLAuthenticationChallenge *)instance
           protectionSpace:(NSURLProtectionSpace *)protectionSpace
                completion:(void (^)(FlutterError *_Nullable))completion {
  if ([self.instanceManager containsInstance:instance]) {
    return;
  }

  FWFURLProtectionSpaceFlutterApiImpl *protectionSpaceApi =
      [[FWFURLProtectionSpaceFlutterApiImpl alloc] initWithBinaryMessenger:self.binaryMessenger
                                                           instanceManager:self.instanceManager];
  [protectionSpaceApi createWithInstance:protectionSpace
                                    host:protectionSpace.host
                                   realm:protectionSpace.realm
                    authenticationMethod:protectionSpace.authenticationMethod
                              completion:^(FlutterError *error) {
                                NSAssert(!error, @"%@", error);
                              }];

  [self.api createWithIdentifier:[self.instanceManager addHostCreatedInstance:instance]
       protectionSpaceIdentifier:[self.instanceManager
                                     identifierWithStrongReferenceForInstance:protectionSpace]
                      completion:completion];
}
@end
