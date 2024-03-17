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

@interface FWFScriptMessageHandlerHostApiTests : XCTestCase
@end

@implementation FWFScriptMessageHandlerHostApiTests
/**
 * Creates a partially mocked FWFScriptMessageHandler and adds it to instanceManager.
 *
 * @param instanceManager Instance manager to add the delegate to.
 * @param identifier Identifier for the delegate added to the instanceManager.
 *
 * @return A mock FWFScriptMessageHandler.
 */
- (id)mockHandlerWithManager:(FWFInstanceManager *)instanceManager identifier:(long)identifier {
  FWFScriptMessageHandler *handler = [[FWFScriptMessageHandler alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  [instanceManager addDartCreatedInstance:handler withIdentifier:0];
  return OCMPartialMock(handler);
}

/**
 * Creates a  mock FWFScriptMessageHandlerFlutterApiImpl with instanceManager.
 *
 * @param instanceManager Instance manager passed to the Flutter API.
 *
 * @return A mock FWFScriptMessageHandlerFlutterApiImpl.
 */
- (id)mockFlutterApiWithManager:(FWFInstanceManager *)instanceManager {
  FWFScriptMessageHandlerFlutterApiImpl *flutterAPI = [[FWFScriptMessageHandlerFlutterApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];
  return OCMPartialMock(flutterAPI);
}

- (void)testCreateWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFScriptMessageHandlerHostApiImpl *hostAPI = [[FWFScriptMessageHandlerHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostAPI createWithIdentifier:0 error:&error];

  FWFScriptMessageHandler *scriptMessageHandler =
      (FWFScriptMessageHandler *)[instanceManager instanceForIdentifier:0];

  XCTAssertTrue([scriptMessageHandler conformsToProtocol:@protocol(WKScriptMessageHandler)]);
  XCTAssertNil(error);
}

- (void)testDidReceiveScriptMessageForHandler {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];

  FWFScriptMessageHandler *mockHandler = [self mockHandlerWithManager:instanceManager identifier:0];
  FWFScriptMessageHandlerFlutterApiImpl *mockFlutterAPI =
      [self mockFlutterApiWithManager:instanceManager];

  OCMStub([mockHandler scriptMessageHandlerAPI]).andReturn(mockFlutterAPI);

  WKUserContentController *userContentController = [[WKUserContentController alloc] init];
  [instanceManager addDartCreatedInstance:userContentController withIdentifier:1];

  WKScriptMessage *mockScriptMessage = OCMClassMock([WKScriptMessage class]);
  OCMStub([mockScriptMessage name]).andReturn(@"name");
  OCMStub([mockScriptMessage body]).andReturn(@"message");

  [mockHandler userContentController:userContentController
             didReceiveScriptMessage:mockScriptMessage];
  OCMVerify([mockFlutterAPI
      didReceiveScriptMessageForHandlerWithIdentifier:0
                      userContentControllerIdentifier:1
                                              message:[OCMArg isKindOfClass:[FWFWKScriptMessageData
                                                                                class]]
                                           completion:OCMOCK_ANY]);
}
@end
