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
@import webview_flutter;

// OCMock library doesn't generate a valid modulemap.
#import <OCMock/OCMock.h>

@interface FLTWKNavigationDelegateTests : XCTestCase

@property(strong, nonatomic) FlutterMethodChannel *mockMethodChannel;
@property(strong, nonatomic) FLTWKNavigationDelegate *navigationDelegate;

@end

@implementation FLTWKNavigationDelegateTests

- (void)setUp {
  self.mockMethodChannel = OCMClassMock(FlutterMethodChannel.class);
  self.navigationDelegate =
      [[FLTWKNavigationDelegate alloc] initWithChannel:self.mockMethodChannel];
}

- (void)testWebViewWebContentProcessDidTerminateCallsRecourseErrorChannel {
  WKWebView *webview = OCMClassMock(WKWebView.class);
  [self.navigationDelegate webViewWebContentProcessDidTerminate:webview];
  OCMVerify([self.mockMethodChannel invokeMethod:@"onWebResourceError"
                                       arguments:[OCMArg checkWithBlock:^BOOL(NSDictionary *args) {
                                         XCTAssertEqualObjects(args[@"errorType"],
                                                               @"webContentProcessTerminated");
                                         return true;
                                       }]]);
}

@end
