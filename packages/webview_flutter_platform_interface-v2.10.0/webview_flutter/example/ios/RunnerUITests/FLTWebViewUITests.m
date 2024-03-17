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

@import XCTest;
@import os.log;

@interface FLTWebViewUITests : XCTestCase
@property(nonatomic, strong) XCUIApplication *app;
@end

@implementation FLTWebViewUITests

- (void)setUp {
  self.continueAfterFailure = NO;

  self.app = [[XCUIApplication alloc] init];
  [self.app launch];
}

- (void)testUserAgent {
  XCUIApplication *app = self.app;
  XCUIElement *menu = app.buttons[@"Show menu"];
  if (![menu waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find menu");
  }
  [menu tap];

  XCUIElement *userAgent = app.buttons[@"Show user agent"];
  if (![userAgent waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find Show user agent");
  }
  NSPredicate *userAgentPredicate =
      [NSPredicate predicateWithFormat:@"label BEGINSWITH 'User Agent: Mozilla/5.0 (iPhone; '"];
  XCUIElement *userAgentPopUp = [app.otherElements elementMatchingPredicate:userAgentPredicate];
  XCTAssertFalse(userAgentPopUp.exists);
  [userAgent tap];
  if (![userAgentPopUp waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find user agent pop up");
  }
}

- (void)testCache {
  XCUIApplication *app = self.app;
  XCUIElement *menu = app.buttons[@"Show menu"];
  if (![menu waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find menu");
  }
  [menu tap];

  XCUIElement *clearCache = app.buttons[@"Clear cache"];
  if (![clearCache waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find Clear cache");
  }
  [clearCache tap];

  [menu tap];

  XCUIElement *listCache = app.buttons[@"List cache"];
  if (![listCache waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find List cache");
  }
  [listCache tap];

  XCUIElement *emptyCachePopup = app.otherElements[@"{\"cacheKeys\":[],\"localStorage\":{}}"];
  if (![emptyCachePopup waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find empty cache pop up");
  }

  [menu tap];
  XCUIElement *addCache = app.buttons[@"Add to cache"];
  if (![addCache waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find Add to cache");
  }
  [addCache tap];
  [menu tap];

  if (![listCache waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find List cache");
  }
  [listCache tap];

  XCUIElement *cachePopup =
      app.otherElements[@"{\"cacheKeys\":[\"test_caches_entry\"],\"localStorage\":{\"test_"
                        @"localStorage\":\"dummy_entry\"}}"];
  if (![cachePopup waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find cache pop up");
  }
}

@end
