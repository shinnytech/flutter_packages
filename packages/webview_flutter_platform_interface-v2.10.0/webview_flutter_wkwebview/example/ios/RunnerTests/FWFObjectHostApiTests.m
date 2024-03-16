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

@interface FWFObjectHostApiTests : XCTestCase
@end

@implementation FWFObjectHostApiTests
/**
 * Creates a partially mocked FWFObject and adds it to instanceManager.
 *
 * @param instanceManager Instance manager to add the delegate to.
 * @param identifier Identifier for the delegate added to the instanceManager.
 *
 * @return A mock FWFObject.
 */
- (id)mockObjectWithManager:(FWFInstanceManager *)instanceManager identifier:(long)identifier {
  FWFObject *object =
      [[FWFObject alloc] initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
                                 instanceManager:instanceManager];

  [instanceManager addDartCreatedInstance:object withIdentifier:0];
  return OCMPartialMock(object);
}

/**
 * Creates a  mock FWFObjectFlutterApiImpl with instanceManager.
 *
 * @param instanceManager Instance manager passed to the Flutter API.
 *
 * @return A mock FWFObjectFlutterApiImpl.
 */
- (id)mockFlutterApiWithManager:(FWFInstanceManager *)instanceManager {
  FWFObjectFlutterApiImpl *flutterAPI = [[FWFObjectFlutterApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];
  return OCMPartialMock(flutterAPI);
}

- (void)testAddObserver {
  NSObject *mockObject = OCMClassMock([NSObject class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockObject withIdentifier:0];

  FWFObjectHostApiImpl *hostAPI =
      [[FWFObjectHostApiImpl alloc] initWithInstanceManager:instanceManager];

  NSObject *observerObject = [[NSObject alloc] init];
  [instanceManager addDartCreatedInstance:observerObject withIdentifier:1];

  FlutterError *error;
  [hostAPI
      addObserverForObjectWithIdentifier:0
                      observerIdentifier:1
                                 keyPath:@"myKey"
                                 options:@[
                                   [FWFNSKeyValueObservingOptionsEnumData
                                       makeWithValue:FWFNSKeyValueObservingOptionsEnumOldValue],
                                   [FWFNSKeyValueObservingOptionsEnumData
                                       makeWithValue:FWFNSKeyValueObservingOptionsEnumNewValue]
                                 ]
                                   error:&error];

  OCMVerify([mockObject addObserver:observerObject
                         forKeyPath:@"myKey"
                            options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                            context:nil]);
  XCTAssertNil(error);
}

- (void)testRemoveObserver {
  NSObject *mockObject = OCMClassMock([NSObject class]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:mockObject withIdentifier:0];

  FWFObjectHostApiImpl *hostAPI =
      [[FWFObjectHostApiImpl alloc] initWithInstanceManager:instanceManager];

  NSObject *observerObject = [[NSObject alloc] init];
  [instanceManager addDartCreatedInstance:observerObject withIdentifier:1];

  FlutterError *error;
  [hostAPI removeObserverForObjectWithIdentifier:0
                              observerIdentifier:1
                                         keyPath:@"myKey"
                                           error:&error];
  OCMVerify([mockObject removeObserver:observerObject forKeyPath:@"myKey"]);
  XCTAssertNil(error);
}

- (void)testDispose {
  NSObject *object = [[NSObject alloc] init];

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addDartCreatedInstance:object withIdentifier:0];

  FWFObjectHostApiImpl *hostAPI =
      [[FWFObjectHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostAPI disposeObjectWithIdentifier:0 error:&error];
  // Only the strong reference is removed, so the weak reference will remain until object is set to
  // nil.
  object = nil;
  XCTAssertFalse([instanceManager containsInstance:object]);
  XCTAssertNil(error);
}

- (void)testObserveValueForKeyPath {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];

  FWFObject *mockObject = [self mockObjectWithManager:instanceManager identifier:0];
  FWFObjectFlutterApiImpl *mockFlutterAPI = [self mockFlutterApiWithManager:instanceManager];

  OCMStub([mockObject objectApi]).andReturn(mockFlutterAPI);

  NSObject *object = [[NSObject alloc] init];
  [instanceManager addDartCreatedInstance:object withIdentifier:1];

  [mockObject observeValueForKeyPath:@"keyPath"
                            ofObject:object
                              change:@{NSKeyValueChangeOldKey : @"key"}
                             context:nil];
  OCMVerify([mockFlutterAPI
      observeValueForObjectWithIdentifier:0
                                  keyPath:@"keyPath"
                         objectIdentifier:1
                               changeKeys:[OCMArg checkWithBlock:^BOOL(
                                                      NSArray<FWFNSKeyValueChangeKeyEnumData *>
                                                          *value) {
                                 return value[0].value == FWFNSKeyValueChangeKeyEnumOldValue;
                               }]
                             changeValues:[OCMArg checkWithBlock:^BOOL(id value) {
                               FWFObjectOrIdentifier *object = (FWFObjectOrIdentifier *)value[0];
                               return !object.isIdentifier && [@"key" isEqual:object.value];
                             }]
                               completion:OCMOCK_ANY]);
}

- (void)testObserveValueForKeyPathWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];

  FWFObject *mockObject = [self mockObjectWithManager:instanceManager identifier:0];
  FWFObjectFlutterApiImpl *mockFlutterAPI = [self mockFlutterApiWithManager:instanceManager];

  OCMStub([mockObject objectApi]).andReturn(mockFlutterAPI);

  NSObject *object = [[NSObject alloc] init];
  [instanceManager addDartCreatedInstance:object withIdentifier:1];

  NSObject *returnedObject = [[NSObject alloc] init];
  [instanceManager addDartCreatedInstance:returnedObject withIdentifier:2];

  [mockObject observeValueForKeyPath:@"keyPath"
                            ofObject:object
                              change:@{NSKeyValueChangeOldKey : returnedObject}
                             context:nil];
  OCMVerify([mockFlutterAPI
      observeValueForObjectWithIdentifier:0
                                  keyPath:@"keyPath"
                         objectIdentifier:1
                               changeKeys:[OCMArg checkWithBlock:^BOOL(
                                                      NSArray<FWFNSKeyValueChangeKeyEnumData *>
                                                          *value) {
                                 return value[0].value == FWFNSKeyValueChangeKeyEnumOldValue;
                               }]
                             changeValues:[OCMArg checkWithBlock:^BOOL(id value) {
                               FWFObjectOrIdentifier *object = (FWFObjectOrIdentifier *)value[0];
                               return object.isIdentifier && [@(2) isEqual:object.value];
                             }]
                               completion:OCMOCK_ANY]);
}
@end
