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

@interface FWFPreferencesHostApiTests : XCTestCase
@end

@implementation FWFPreferencesHostApiTests
- (void)testCreateFromWebViewConfigurationWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFPreferencesHostApiImpl *hostAPI =
      [[FWFPreferencesHostApiImpl alloc] initWithInstanceManager:instanceManager];

  [instanceManager addDartCreatedInstance:[[WKWebViewConfiguration alloc] init] withIdentifier:0];

  FlutterError *error;
  [hostAPI createFromWebViewConfigurationWithIdentifier:1 configurationIdentifier:0 error:&error];
  WKPreferences *preferences = (WKPreferences *)[instanceManager instanceForIdentifier:1];
  XCTAssertTrue([preferences isKindOfClass:[WKPreferences class]]);
  XCTAssertNil(error);
}

- (void)testSetJavaScriptEnabled {
  WKPreferences *mockPreferences = OCMClassMock([WKPreferences class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockPreferences withIdentifier:0];

  FWFPreferencesHostApiImpl *hostAPI =
      [[FWFPreferencesHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostAPI setJavaScriptEnabledForPreferencesWithIdentifier:0 isEnabled:YES error:&error];
  OCMVerify([mockPreferences setJavaScriptEnabled:YES]);
  XCTAssertNil(error);
}
@end
