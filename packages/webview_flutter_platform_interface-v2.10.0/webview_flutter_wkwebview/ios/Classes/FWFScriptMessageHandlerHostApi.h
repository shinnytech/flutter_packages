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
 * Flutter api implementation for WKScriptMessageHandler.
 *
 * Handles making callbacks to Dart for a WKScriptMessageHandler.
 */
@interface FWFScriptMessageHandlerFlutterApiImpl : FWFWKScriptMessageHandlerFlutterApi
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

/**
 * Implementation of WKScriptMessageHandler for FWFScriptMessageHandlerHostApiImpl.
 */
@interface FWFScriptMessageHandler : FWFObject <WKScriptMessageHandler>
@property(readonly, nonnull, nonatomic)
    FWFScriptMessageHandlerFlutterApiImpl *scriptMessageHandlerAPI;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

/**
 * Host api implementation for WKScriptMessageHandler.
 *
 * Handles creating WKScriptMessageHandler that intercommunicate with a paired Dart object.
 */
@interface FWFScriptMessageHandlerHostApiImpl : NSObject <FWFWKScriptMessageHandlerHostApi>
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

NS_ASSUME_NONNULL_END
