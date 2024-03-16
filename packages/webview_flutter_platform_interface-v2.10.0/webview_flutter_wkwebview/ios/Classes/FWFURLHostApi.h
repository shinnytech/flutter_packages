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
#import <Foundation/Foundation.h>
#import "FWFGeneratedWebKitApis.h"
#import "FWFInstanceManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Host API implementation for `NSURL`.
 *
 * This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or method calls on the associated native class or an instance of the class.
 */
@interface FWFURLHostApiImpl : NSObject <FWFNSUrlHostApi>
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
@end

/**
 * Flutter API implementation for `NSURL`.
 *
 * This class may handle instantiating and adding Dart instances that are attached to a native
 * instance or sending callback methods from an overridden native class.
 */
@interface FWFURLFlutterApiImpl : NSObject
/**
 * The Flutter API used to send messages back to Dart.
 */
@property FWFNSUrlFlutterApi *api;
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                        instanceManager:(FWFInstanceManager *)instanceManager;
/**
 * Sends a message to Dart to create a new Dart instance and add it to the `InstanceManager`.
 */
- (void)create:(NSURL *)instance completion:(void (^)(FlutterError *_Nullable))completion;
@end

NS_ASSUME_NONNULL_END
