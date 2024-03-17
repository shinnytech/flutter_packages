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
@import webview_flutter_wkwebview.Test;

#import <OCMock/OCMock.h>

@interface FWFUIDelegateHostApiTests : XCTestCase
@end

@implementation FWFUIDelegateHostApiTests
/**
 * Creates a partially mocked FWFUIDelegate and adds it to instanceManager.
 *
 * @param instanceManager Instance manager to add the delegate to.
 * @param identifier Identifier for the delegate added to the instanceManager.
 *
 * @return A mock FWFUIDelegate.
 */
- (id)mockDelegateWithManager:(FWFInstanceManager *)instanceManager identifier:(long)identifier {
  FWFUIDelegate *delegate = [[FWFUIDelegate alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  [instanceManager addDartCreatedInstance:delegate withIdentifier:0];
  return OCMPartialMock(delegate);
}

/**
 * Creates a  mock FWFUIDelegateFlutterApiImpl with instanceManager.
 *
 * @param instanceManager Instance manager passed to the Flutter API.
 *
 * @return A mock FWFUIDelegateFlutterApiImpl.
 */
- (id)mockFlutterApiWithManager:(FWFInstanceManager *)instanceManager {
  FWFUIDelegateFlutterApiImpl *flutterAPI = [[FWFUIDelegateFlutterApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];
  return OCMPartialMock(flutterAPI);
}

- (void)testCreateWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFUIDelegateHostApiImpl *hostAPI = [[FWFUIDelegateHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostAPI createWithIdentifier:0 error:&error];
  FWFUIDelegate *delegate = (FWFUIDelegate *)[instanceManager instanceForIdentifier:0];

  XCTAssertTrue([delegate conformsToProtocol:@protocol(WKUIDelegate)]);
  XCTAssertNil(error);
}

- (void)testOnCreateWebViewForDelegateWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];

  FWFUIDelegate *mockDelegate = [self mockDelegateWithManager:instanceManager identifier:0];
  FWFUIDelegateFlutterApiImpl *mockFlutterAPI = [self mockFlutterApiWithManager:instanceManager];

  OCMStub([mockDelegate UIDelegateAPI]).andReturn(mockFlutterAPI);

  WKWebView *mockWebView = OCMClassMock([WKWebView class]);
  [instanceManager addDartCreatedInstance:mockWebView withIdentifier:1];

  WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  id mockConfigurationFlutterApi = OCMPartialMock(mockFlutterAPI.webViewConfigurationFlutterApi);
  OCMStub([mockConfigurationFlutterApi createWithIdentifier:0 completion:OCMOCK_ANY])
      .ignoringNonObjectArgs();

  WKNavigationAction *mockNavigationAction = OCMClassMock([WKNavigationAction class]);
  OCMStub([mockNavigationAction request])
      .andReturn([NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.flutter.dev"]]);

  WKFrameInfo *mockFrameInfo = OCMClassMock([WKFrameInfo class]);
  OCMStub([mockFrameInfo isMainFrame]).andReturn(YES);
  OCMStub([mockNavigationAction targetFrame]).andReturn(mockFrameInfo);

  // Creating the webview will create a configuration on the host side, using the next available
  // identifier, so save that for checking against later.
  NSInteger configurationIdentifier = instanceManager.nextIdentifier;
  [mockDelegate webView:mockWebView
      createWebViewWithConfiguration:configuration
                 forNavigationAction:mockNavigationAction
                      windowFeatures:OCMClassMock([WKWindowFeatures class])];
  OCMVerify([mockFlutterAPI
      onCreateWebViewForDelegateWithIdentifier:0
                             webViewIdentifier:1
                       configurationIdentifier:configurationIdentifier
                              navigationAction:[OCMArg
                                                   isKindOfClass:[FWFWKNavigationActionData class]]
                                    completion:OCMOCK_ANY]);
}

- (void)testRequestMediaCapturePermissionForOrigin API_AVAILABLE(ios(15.0)) {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];

  FWFUIDelegate *mockDelegate = [self mockDelegateWithManager:instanceManager identifier:0];
  FWFUIDelegateFlutterApiImpl *mockFlutterAPI = [self mockFlutterApiWithManager:instanceManager];

  OCMStub([mockDelegate UIDelegateAPI]).andReturn(mockFlutterAPI);

  WKWebView *mockWebView = OCMClassMock([WKWebView class]);
  [instanceManager addDartCreatedInstance:mockWebView withIdentifier:1];

  WKSecurityOrigin *mockSecurityOrigin = OCMClassMock([WKSecurityOrigin class]);
  OCMStub([mockSecurityOrigin host]).andReturn(@"");
  OCMStub([mockSecurityOrigin port]).andReturn(0);
  OCMStub([mockSecurityOrigin protocol]).andReturn(@"");

  WKFrameInfo *mockFrameInfo = OCMClassMock([WKFrameInfo class]);
  OCMStub([mockFrameInfo isMainFrame]).andReturn(YES);

  [mockDelegate webView:mockWebView
      requestMediaCapturePermissionForOrigin:mockSecurityOrigin
                            initiatedByFrame:mockFrameInfo
                                        type:WKMediaCaptureTypeMicrophone
                             decisionHandler:^(WKPermissionDecision decision){
                             }];

  OCMVerify([mockFlutterAPI
      requestMediaCapturePermissionForDelegateWithIdentifier:0
                                           webViewIdentifier:1
                                                      origin:[OCMArg isKindOfClass:
                                                                         [FWFWKSecurityOriginData
                                                                             class]]
                                                       frame:[OCMArg
                                                                 isKindOfClass:[FWFWKFrameInfoData
                                                                                   class]]
                                                        type:[OCMArg isKindOfClass:
                                                                         [FWFWKMediaCaptureTypeData
                                                                             class]]
                                                  completion:OCMOCK_ANY]);
}
@end
