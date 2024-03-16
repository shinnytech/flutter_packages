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
 * A set of Flutter and Dart assets used by a `FlutterEngine` to initialize execution.
 *
 * Default implementation delegates methods to FlutterDartProject.
 */
@interface FWFAssetManager : NSObject
- (NSString *)lookupKeyForAsset:(NSString *)asset;
@end

/**
 * Implementation of WKWebView that can be used as a FlutterPlatformView.
 */
@interface FWFWebView : WKWebView <FlutterPlatformView>
@property(readonly, nonnull, nonatomic) FWFObjectFlutterApiImpl *objectApi;

- (instancetype)initWithFrame:(CGRect)frame
                configuration:(nonnull WKWebViewConfiguration *)configuration
              binaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
              instanceManager:(FWFInstanceManager *)instanceManager;
@end

/**
 * Host api implementation for WKWebView.
 *
 * Handles creating WKWebViews that intercommunicate with a paired Dart object.
 */
@interface FWFWebViewHostApiImpl : NSObject <FWFWKWebViewHostApi>
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager
                                 bundle:(NSBundle *)bundle
                           assetManager:(FWFAssetManager *)assetManager;
@end

NS_ASSUME_NONNULL_END
