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

@import Flutter;
@import XCTest;
@import webview_flutter_wkwebview;

#import <OCMock/OCMock.h>

@interface FWFURLProtectionSpaceHostApiTests : XCTestCase
@end

@implementation FWFURLProtectionSpaceHostApiTests
- (void)testFlutterApiCreate {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFURLProtectionSpaceFlutterApiImpl *flutterApi = [[FWFURLProtectionSpaceFlutterApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  flutterApi.api = OCMClassMock([FWFNSUrlProtectionSpaceFlutterApi class]);

  NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:@"host"
                                                                                port:0
                                                                            protocol:nil
                                                                               realm:@"realm"
                                                                authenticationMethod:nil];
  [flutterApi createWithInstance:protectionSpace
                            host:@"host"
                           realm:@"realm"
            authenticationMethod:@"method"
                      completion:^(FlutterError *error){

                      }];

  long identifier = [instanceManager identifierWithStrongReferenceForInstance:protectionSpace];
  OCMVerify([flutterApi.api createWithIdentifier:identifier
                                            host:@"host"
                                           realm:@"realm"
                            authenticationMethod:@"method"
                                      completion:OCMOCK_ANY]);
}
@end
