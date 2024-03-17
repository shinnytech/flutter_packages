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

@interface FWFWebsiteDataStoreHostApiTests : XCTestCase
@end

@implementation FWFWebsiteDataStoreHostApiTests
- (void)testCreateFromWebViewConfigurationWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFWebsiteDataStoreHostApiImpl *hostAPI =
      [[FWFWebsiteDataStoreHostApiImpl alloc] initWithInstanceManager:instanceManager];

  [instanceManager addDartCreatedInstance:[[WKWebViewConfiguration alloc] init] withIdentifier:0];

  FlutterError *error;
  [hostAPI createFromWebViewConfigurationWithIdentifier:1 configurationIdentifier:0 error:&error];
  WKWebsiteDataStore *dataStore = (WKWebsiteDataStore *)[instanceManager instanceForIdentifier:1];
  XCTAssertTrue([dataStore isKindOfClass:[WKWebsiteDataStore class]]);
  XCTAssertNil(error);
}

- (void)testCreateDefaultDataStoreWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFWebsiteDataStoreHostApiImpl *hostAPI =
      [[FWFWebsiteDataStoreHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostAPI createDefaultDataStoreWithIdentifier:0 error:&error];
  WKWebsiteDataStore *dataStore = (WKWebsiteDataStore *)[instanceManager instanceForIdentifier:0];
  XCTAssertEqualObjects(dataStore, [WKWebsiteDataStore defaultDataStore]);
  XCTAssertNil(error);
}

- (void)testRemoveDataOfTypes {
  WKWebsiteDataStore *mockWebsiteDataStore = OCMClassMock([WKWebsiteDataStore class]);

  WKWebsiteDataRecord *mockDataRecord = OCMClassMock([WKWebsiteDataRecord class]);
  OCMStub([mockWebsiteDataStore
      fetchDataRecordsOfTypes:[NSSet setWithObject:WKWebsiteDataTypeLocalStorage]
            completionHandler:([OCMArg invokeBlockWithArgs:@[ mockDataRecord ], nil])]);

  OCMStub([mockWebsiteDataStore
      removeDataOfTypes:[NSSet setWithObject:WKWebsiteDataTypeLocalStorage]
          modifiedSince:[NSDate dateWithTimeIntervalSince1970:45.0]
      completionHandler:([OCMArg invokeBlock])]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockWebsiteDataStore withIdentifier:0];

  FWFWebsiteDataStoreHostApiImpl *hostAPI =
      [[FWFWebsiteDataStoreHostApiImpl alloc] initWithInstanceManager:instanceManager];

  NSNumber __block *returnValue;
  FlutterError *__block blockError;
  [hostAPI removeDataFromDataStoreWithIdentifier:0
                                         ofTypes:@[
                                           [FWFWKWebsiteDataTypeEnumData
                                               makeWithValue:FWFWKWebsiteDataTypeEnumLocalStorage]
                                         ]
                                   modifiedSince:45.0
                                      completion:^(NSNumber *result, FlutterError *error) {
                                        returnValue = result;
                                        blockError = error;
                                      }];
  XCTAssertEqualObjects(returnValue, @YES);
  // Asserts whether the NSNumber will be deserialized by the standard codec as a boolean.
  XCTAssertEqual(CFGetTypeID((__bridge CFTypeRef)(returnValue)), CFBooleanGetTypeID());
  XCTAssertNil(blockError);
}
@end
