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

#import "FWFHTTPCookieStoreHostApi.h"
#import "FWFDataConverters.h"
#import "FWFWebsiteDataStoreHostApi.h"

@interface FWFHTTPCookieStoreHostApiImpl ()
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFHTTPCookieStoreHostApiImpl
- (instancetype)initWithInstanceManager:(FWFInstanceManager *)instanceManager {
  self = [self init];
  if (self) {
    _instanceManager = instanceManager;
  }
  return self;
}

- (WKHTTPCookieStore *)HTTPCookieStoreForIdentifier:(NSInteger)identifier {
  return (WKHTTPCookieStore *)[self.instanceManager instanceForIdentifier:identifier];
}

- (void)createFromWebsiteDataStoreWithIdentifier:(NSInteger)identifier
                             dataStoreIdentifier:(NSInteger)websiteDataStoreIdentifier
                                           error:(FlutterError *_Nullable __autoreleasing *_Nonnull)
                                                     error {
  WKWebsiteDataStore *dataStore =
      (WKWebsiteDataStore *)[self.instanceManager instanceForIdentifier:websiteDataStoreIdentifier];
  [self.instanceManager addDartCreatedInstance:dataStore.httpCookieStore withIdentifier:identifier];
}

- (void)setCookieForStoreWithIdentifier:(NSInteger)identifier
                                 cookie:(nonnull FWFNSHttpCookieData *)cookie
                             completion:(nonnull void (^)(FlutterError *_Nullable))completion {
  NSHTTPCookie *nsCookie = FWFNativeNSHTTPCookieFromCookieData(cookie);

  [[self HTTPCookieStoreForIdentifier:identifier] setCookie:nsCookie
                                          completionHandler:^{
                                            completion(nil);
                                          }];
}
@end
