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

@interface FWFURLCredentialHostApiTests : XCTestCase
@end

@implementation FWFURLCredentialHostApiTests
- (void)testHostApiCreate {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];

  FWFURLCredentialHostApiImpl *hostApi = [[FWFURLCredentialHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostApi createWithUserWithIdentifier:0
                                   user:@"user"
                               password:@"password"
                            persistence:FWFNSUrlCredentialPersistencePermanent
                                  error:&error];
  XCTAssertNil(error);

  NSURLCredential *credential = (NSURLCredential *)[instanceManager instanceForIdentifier:0];
  XCTAssertEqualObjects(credential.user, @"user");
  XCTAssertEqualObjects(credential.password, @"password");
  XCTAssertEqual(credential.persistence, NSURLCredentialPersistencePermanent);
}
@end
