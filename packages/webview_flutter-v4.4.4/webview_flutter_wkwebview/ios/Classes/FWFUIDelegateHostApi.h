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

#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

#import "FWFGeneratedWebKitApis.h"
#import "FWFInstanceManager.h"
#import "FWFObjectHostApi.h"
#import "FWFWebViewConfigurationHostApi.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Flutter api implementation for WKUIDelegate.
 *
 * Handles making callbacks to Dart for a WKUIDelegate.
 */
@interface FWFUIDelegateFlutterApiImpl : FWFWKUIDelegateFlutterApi
@property(readonly, nonatomic)
    FWFWebViewConfigurationFlutterApiImpl *webViewConfigurationFlutterApi;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

/**
 * Implementation of WKUIDelegate for FWFUIDelegateHostApiImpl.
 */
@interface FWFUIDelegate : FWFObject <WKUIDelegate>
@property(readonly, nonnull, nonatomic) FWFUIDelegateFlutterApiImpl *UIDelegateAPI;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

/**
 * Host api implementation for WKUIDelegate.
 *
 * Handles creating WKUIDelegate that intercommunicate with a paired Dart object.
 */
@interface FWFUIDelegateHostApiImpl : NSObject <FWFWKUIDelegateHostApi>
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

NS_ASSUME_NONNULL_END
