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

#import "FWFInstanceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWFInstanceManager ()
/**
 * The next identifier that will be used for a host-created instance.
 */
@property long nextIdentifier;

/**
 * The number of instances stored as a strong reference.
 *
 * Added for debugging purposes.
 */
- (NSUInteger)strongInstanceCount;

/**
 * The number of instances stored as a weak reference.
 *
 * Added for debugging purposes. NSMapTables that store keys or objects as weak reference will be
 * reclaimed nondeterministically.
 */
- (NSUInteger)weakInstanceCount;
@end

NS_ASSUME_NONNULL_END
