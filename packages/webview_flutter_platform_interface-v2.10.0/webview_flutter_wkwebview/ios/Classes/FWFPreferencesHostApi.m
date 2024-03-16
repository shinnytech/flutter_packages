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

#import "FWFPreferencesHostApi.h"
#import "FWFWebViewConfigurationHostApi.h"

@interface FWFPreferencesHostApiImpl ()
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFPreferencesHostApiImpl
- (instancetype)initWithInstanceManager:(FWFInstanceManager *)instanceManager {
  self = [self init];
  if (self) {
    _instanceManager = instanceManager;
  }
  return self;
}

- (WKPreferences *)preferencesForIdentifier:(NSInteger)identifier {
  return (WKPreferences *)[self.instanceManager instanceForIdentifier:identifier];
}

- (void)createWithIdentifier:(NSInteger)identifier error:(FlutterError *_Nullable *_Nonnull)error {
  WKPreferences *preferences = [[WKPreferences alloc] init];
  [self.instanceManager addDartCreatedInstance:preferences withIdentifier:identifier];
}

- (void)createFromWebViewConfigurationWithIdentifier:(NSInteger)identifier
                             configurationIdentifier:(NSInteger)configurationIdentifier
                                               error:(FlutterError *_Nullable *_Nonnull)error {
  WKWebViewConfiguration *configuration = (WKWebViewConfiguration *)[self.instanceManager
      instanceForIdentifier:configurationIdentifier];
  [self.instanceManager addDartCreatedInstance:configuration.preferences withIdentifier:identifier];
}

- (void)setJavaScriptEnabledForPreferencesWithIdentifier:(NSInteger)identifier
                                               isEnabled:(BOOL)enabled
                                                   error:(FlutterError *_Nullable *_Nonnull)error {
  [[self preferencesForIdentifier:identifier] setJavaScriptEnabled:enabled];
}
@end
