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

@interface FWFScrollViewHostApiTests : XCTestCase
@end

@implementation FWFScrollViewHostApiTests
- (void)testGetContentOffset {
  UIScrollView *mockScrollView = OCMClassMock([UIScrollView class]);
  OCMStub([mockScrollView contentOffset]).andReturn(CGPointMake(1.0, 2.0));

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockScrollView withIdentifier:0];

  FWFScrollViewHostApiImpl *hostAPI =
      [[FWFScrollViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  NSArray<NSNumber *> *expectedValue = @[ @1.0, @2.0 ];
  XCTAssertEqualObjects([hostAPI contentOffsetForScrollViewWithIdentifier:0 error:&error],
                        expectedValue);
  XCTAssertNil(error);
}

- (void)testScrollBy {
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
  scrollView.contentOffset = CGPointMake(1, 2);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:scrollView withIdentifier:0];

  FWFScrollViewHostApiImpl *hostAPI =
      [[FWFScrollViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostAPI scrollByForScrollViewWithIdentifier:0 x:1 y:2 error:&error];
  XCTAssertEqual(scrollView.contentOffset.x, 2);
  XCTAssertEqual(scrollView.contentOffset.y, 4);
  XCTAssertNil(error);
}

- (void)testSetContentOffset {
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:scrollView withIdentifier:0];

  FWFScrollViewHostApiImpl *hostAPI =
      [[FWFScrollViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostAPI setContentOffsetForScrollViewWithIdentifier:0 toX:1 y:2 error:&error];
  XCTAssertEqual(scrollView.contentOffset.x, 1);
  XCTAssertEqual(scrollView.contentOffset.y, 2);
  XCTAssertNil(error);
}
@end
