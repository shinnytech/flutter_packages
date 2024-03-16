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

@interface FWFHTTPCookieStoreHostApiTests : XCTestCase
@end

@implementation FWFHTTPCookieStoreHostApiTests
- (void)testCreateFromWebsiteDataStoreWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFHTTPCookieStoreHostApiImpl *hostAPI =
      [[FWFHTTPCookieStoreHostApiImpl alloc] initWithInstanceManager:instanceManager];

  WKWebsiteDataStore *mockDataStore = OCMClassMock([WKWebsiteDataStore class]);
  OCMStub([mockDataStore httpCookieStore]).andReturn(OCMClassMock([WKHTTPCookieStore class]));
  [instanceManager addDartCreatedInstance:mockDataStore withIdentifier:0];

  FlutterError *error;
  [hostAPI createFromWebsiteDataStoreWithIdentifier:1 dataStoreIdentifier:0 error:&error];
  WKHTTPCookieStore *cookieStore = (WKHTTPCookieStore *)[instanceManager instanceForIdentifier:1];
  XCTAssertTrue([cookieStore isKindOfClass:[WKHTTPCookieStore class]]);
  XCTAssertNil(error);
}

- (void)testSetCookie {
  WKHTTPCookieStore *mockHttpCookieStore = OCMClassMock([WKHTTPCookieStore class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockHttpCookieStore withIdentifier:0];

  FWFHTTPCookieStoreHostApiImpl *hostAPI =
      [[FWFHTTPCookieStoreHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FWFNSHttpCookieData *cookieData = [FWFNSHttpCookieData
      makeWithPropertyKeys:@[ [FWFNSHttpCookiePropertyKeyEnumData
                               makeWithValue:FWFNSHttpCookiePropertyKeyEnumName] ]
            propertyValues:@[ @"hello" ]];
  FlutterError *__block blockError;
  [hostAPI setCookieForStoreWithIdentifier:0
                                    cookie:cookieData
                                completion:^(FlutterError *error) {
                                  blockError = error;
                                }];
  OCMVerify([mockHttpCookieStore
              setCookie:[NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName : @"hello"}]
      completionHandler:OCMOCK_ANY]);
  XCTAssertNil(blockError);
}
@end
