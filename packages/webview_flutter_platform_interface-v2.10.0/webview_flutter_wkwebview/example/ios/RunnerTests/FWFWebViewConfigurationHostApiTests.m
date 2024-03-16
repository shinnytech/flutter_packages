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

@interface FWFWebViewConfigurationHostApiTests : XCTestCase
@end

@implementation FWFWebViewConfigurationHostApiTests
- (void)testCreateWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFWebViewConfigurationHostApiImpl *hostAPI = [[FWFWebViewConfigurationHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostAPI createWithIdentifier:0 error:&error];
  WKWebViewConfiguration *configuration =
      (WKWebViewConfiguration *)[instanceManager instanceForIdentifier:0];
  XCTAssertTrue([configuration isKindOfClass:[WKWebViewConfiguration class]]);
  XCTAssertNil(error);
}

- (void)testCreateFromWebViewWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFWebViewConfigurationHostApiImpl *hostAPI = [[FWFWebViewConfigurationHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  WKWebView *mockWebView = OCMClassMock([WKWebView class]);
  OCMStub([mockWebView configuration]).andReturn(OCMClassMock([WKWebViewConfiguration class]));
  [instanceManager addDartCreatedInstance:mockWebView withIdentifier:0];

  FlutterError *error;
  [hostAPI createFromWebViewWithIdentifier:1 webViewIdentifier:0 error:&error];
  WKWebViewConfiguration *configuration =
      (WKWebViewConfiguration *)[instanceManager instanceForIdentifier:1];
  XCTAssertTrue([configuration isKindOfClass:[WKWebViewConfiguration class]]);
  XCTAssertNil(error);
}

- (void)testSetAllowsInlineMediaPlayback {
  WKWebViewConfiguration *mockWebViewConfiguration = OCMClassMock([WKWebViewConfiguration class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockWebViewConfiguration withIdentifier:0];

  FWFWebViewConfigurationHostApiImpl *hostAPI = [[FWFWebViewConfigurationHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostAPI setAllowsInlineMediaPlaybackForConfigurationWithIdentifier:0 isAllowed:NO error:&error];
  OCMVerify([mockWebViewConfiguration setAllowsInlineMediaPlayback:NO]);
  XCTAssertNil(error);
}

- (void)testSetLimitsNavigationsToAppBoundDomains API_AVAILABLE(ios(14.0)) {
  WKWebViewConfiguration *mockWebViewConfiguration = OCMClassMock([WKWebViewConfiguration class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockWebViewConfiguration withIdentifier:0];

  FWFWebViewConfigurationHostApiImpl *hostAPI = [[FWFWebViewConfigurationHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostAPI setLimitsNavigationsToAppBoundDomainsForConfigurationWithIdentifier:0
                                                                     isLimited:NO
                                                                         error:&error];
  OCMVerify([mockWebViewConfiguration setLimitsNavigationsToAppBoundDomains:NO]);
  XCTAssertNil(error);
}

- (void)testSetMediaTypesRequiringUserActionForPlayback {
  WKWebViewConfiguration *mockWebViewConfiguration = OCMClassMock([WKWebViewConfiguration class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockWebViewConfiguration withIdentifier:0];

  FWFWebViewConfigurationHostApiImpl *hostAPI = [[FWFWebViewConfigurationHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostAPI
      setMediaTypesRequiresUserActionForConfigurationWithIdentifier:0
                                                           forTypes:@[
                                                             [FWFWKAudiovisualMediaTypeEnumData
                                                                 makeWithValue:
                                                                     FWFWKAudiovisualMediaTypeEnumAudio],
                                                             [FWFWKAudiovisualMediaTypeEnumData
                                                                 makeWithValue:
                                                                     FWFWKAudiovisualMediaTypeEnumVideo]
                                                           ]
                                                              error:&error];
  OCMVerify([mockWebViewConfiguration
      setMediaTypesRequiringUserActionForPlayback:(WKAudiovisualMediaTypeAudio |
                                                   WKAudiovisualMediaTypeVideo)]);
  XCTAssertNil(error);
}
@end
