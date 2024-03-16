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

NS_ASSUME_NONNULL_BEGIN

/**
 * Flutter api implementation for WKWebViewConfiguration.
 *
 * Handles making callbacks to Dart for a WKWebViewConfiguration.
 */
@interface FWFWebViewConfigurationFlutterApiImpl : FWFWKWebViewConfigurationFlutterApi
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;

- (void)createWithConfiguration:(WKWebViewConfiguration *)configuration
                     completion:(void (^)(FlutterError *_Nullable))completion;
@end

/**
 * Implementation of WKWebViewConfiguration for FWFWebViewConfigurationHostApiImpl.
 */
@interface FWFWebViewConfiguration : WKWebViewConfiguration
@property(readonly, nonnull, nonatomic) FWFObjectFlutterApiImpl *objectApi;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

/**
 * Host api implementation for WKWebViewConfiguration.
 *
 * Handles creating WKWebViewConfiguration that intercommunicate with a paired Dart object.
 */
@interface FWFWebViewConfigurationHostApiImpl : NSObject <FWFWKWebViewConfigurationHostApi>
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

NS_ASSUME_NONNULL_END
