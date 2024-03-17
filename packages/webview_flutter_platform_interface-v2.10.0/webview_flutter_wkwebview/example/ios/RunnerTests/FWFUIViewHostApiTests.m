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

@interface FWFUIViewHostApiTests : XCTestCase
@end

@implementation FWFUIViewHostApiTests
- (void)testSetBackgroundColor {
  UIView *mockUIView = OCMClassMock([UIView class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockUIView withIdentifier:0];

  FWFUIViewHostApiImpl *hostAPI =
      [[FWFUIViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostAPI setBackgroundColorForViewWithIdentifier:0 toValue:@123 error:&error];

  OCMVerify([mockUIView setBackgroundColor:[UIColor colorWithRed:(123 >> 16 & 0xff) / 255.0
                                                           green:(123 >> 8 & 0xff) / 255.0
                                                            blue:(123 & 0xff) / 255.0
                                                           alpha:(123 >> 24 & 0xff) / 255.0]]);
  XCTAssertNil(error);
}

- (void)testSetOpaque {
  UIView *mockUIView = OCMClassMock([UIView class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockUIView withIdentifier:0];

  FWFUIViewHostApiImpl *hostAPI =
      [[FWFUIViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostAPI setOpaqueForViewWithIdentifier:0 isOpaque:YES error:&error];
  OCMVerify([mockUIView setOpaque:YES]);
  XCTAssertNil(error);
}

@end
