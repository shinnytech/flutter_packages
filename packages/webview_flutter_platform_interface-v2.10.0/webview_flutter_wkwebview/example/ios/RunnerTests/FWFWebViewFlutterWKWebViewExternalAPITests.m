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

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@import webview_flutter_wkwebview;

@interface FWFWebViewFlutterWKWebViewExternalAPITests : XCTestCase
@end

@implementation FWFWebViewFlutterWKWebViewExternalAPITests
- (void)testWebViewForIdentifier {
  WKWebView *webView = [[WKWebView alloc] init];
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:webView withIdentifier:0];

  id<FlutterPluginRegistry> mockPluginRegistry = OCMProtocolMock(@protocol(FlutterPluginRegistry));
  OCMStub([mockPluginRegistry valuePublishedByPlugin:@"FLTWebViewFlutterPlugin"])
      .andReturn(instanceManager);

  XCTAssertEqualObjects(
      [FWFWebViewFlutterWKWebViewExternalAPI webViewForIdentifier:0
                                               withPluginRegistry:mockPluginRegistry],
      webView);
}
@end
