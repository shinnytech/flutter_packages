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

@interface FWFURLTests : XCTestCase
@end

@implementation FWFURLTests
- (void)testAbsoluteString {
  NSURL *mockUrl = OCMClassMock([NSURL class]);
  OCMStub([mockUrl absoluteString]).andReturn(@"https://www.google.com");

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockUrl withIdentifier:0];

  FWFURLHostApiImpl *hostApi = [[FWFURLHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  XCTAssertEqualObjects([hostApi absoluteStringForNSURLWithIdentifier:0 error:&error],
                        @"https://www.google.com");
  XCTAssertNil(error);
}

- (void)testFlutterApiCreate {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFURLFlutterApiImpl *flutterApi = [[FWFURLFlutterApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  flutterApi.api = OCMClassMock([FWFNSUrlFlutterApi class]);

  NSURL *url = [[NSURL alloc] initWithString:@"https://www.google.com"];
  [flutterApi create:url
          completion:^(FlutterError *error){
          }];

  long identifier = [instanceManager identifierWithStrongReferenceForInstance:url];
  OCMVerify([flutterApi.api createWithIdentifier:identifier completion:OCMOCK_ANY]);
}
@end
