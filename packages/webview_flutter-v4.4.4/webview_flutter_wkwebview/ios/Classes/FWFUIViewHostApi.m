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

#import "FWFUIViewHostApi.h"

@interface FWFUIViewHostApiImpl ()
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFUIViewHostApiImpl
- (instancetype)initWithInstanceManager:(FWFInstanceManager *)instanceManager {
  self = [self init];
  if (self) {
    _instanceManager = instanceManager;
  }
  return self;
}

- (UIView *)viewForIdentifier:(NSInteger)identifier {
  return (UIView *)[self.instanceManager instanceForIdentifier:identifier];
}

- (void)setBackgroundColorForViewWithIdentifier:(NSInteger)identifier
                                        toValue:(nullable NSNumber *)color
                                          error:(FlutterError *_Nullable *_Nonnull)error {
  if (color == nil) {
    [[self viewForIdentifier:identifier] setBackgroundColor:nil];
  }
  int colorInt = color.intValue;
  UIColor *colorObject = [UIColor colorWithRed:(colorInt >> 16 & 0xff) / 255.0
                                         green:(colorInt >> 8 & 0xff) / 255.0
                                          blue:(colorInt & 0xff) / 255.0
                                         alpha:(colorInt >> 24 & 0xff) / 255.0];
  [[self viewForIdentifier:identifier] setBackgroundColor:colorObject];
}

- (void)setOpaqueForViewWithIdentifier:(NSInteger)identifier
                              isOpaque:(BOOL)opaque
                                 error:(FlutterError *_Nullable *_Nonnull)error {
  [[self viewForIdentifier:identifier] setOpaque:opaque];
}
@end
