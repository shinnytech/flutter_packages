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

#import "FLTWebViewFlutterPlugin.h"
#import "FWFGeneratedWebKitApis.h"
#import "FWFHTTPCookieStoreHostApi.h"
#import "FWFInstanceManager.h"
#import "FWFNavigationDelegateHostApi.h"
#import "FWFObjectHostApi.h"
#import "FWFPreferencesHostApi.h"
#import "FWFScriptMessageHandlerHostApi.h"
#import "FWFScrollViewHostApi.h"
#import "FWFUIDelegateHostApi.h"
#import "FWFUIViewHostApi.h"
#import "FWFURLCredentialHostApi.h"
#import "FWFURLHostApi.h"
#import "FWFUserContentControllerHostApi.h"
#import "FWFWebViewConfigurationHostApi.h"
#import "FWFWebViewHostApi.h"
#import "FWFWebsiteDataStoreHostApi.h"

@interface FWFWebViewFactory : NSObject <FlutterPlatformViewFactory>
@property(nonatomic, weak) FWFInstanceManager *instanceManager;

- (instancetype)initWithManager:(FWFInstanceManager *)manager;
@end

@implementation FWFWebViewFactory
- (instancetype)initWithManager:(FWFInstanceManager *)manager {
  self = [self init];
  if (self) {
    _instanceManager = manager;
  }
  return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                    viewIdentifier:(int64_t)viewId
                                         arguments:(id _Nullable)args {
  NSNumber *identifier = (NSNumber *)args;
  FWFWebView *webView =
      (FWFWebView *)[self.instanceManager instanceForIdentifier:identifier.longValue];
  webView.frame = frame;
  return webView;
}

@end

@implementation FLTWebViewFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FWFInstanceManager *instanceManager =
      [[FWFInstanceManager alloc] initWithDeallocCallback:^(long identifier) {
        FWFObjectFlutterApiImpl *objectApi = [[FWFObjectFlutterApiImpl alloc]
            initWithBinaryMessenger:registrar.messenger
                    instanceManager:[[FWFInstanceManager alloc] init]];

        dispatch_async(dispatch_get_main_queue(), ^{
          [objectApi disposeObjectWithIdentifier:identifier
                                      completion:^(FlutterError *error) {
                                        NSAssert(!error, @"%@", error);
                                      }];
        });
      }];
  SetUpFWFWKHttpCookieStoreHostApi(
      registrar.messenger,
      [[FWFHTTPCookieStoreHostApiImpl alloc] initWithInstanceManager:instanceManager]);
  SetUpFWFWKNavigationDelegateHostApi(
      registrar.messenger,
      [[FWFNavigationDelegateHostApiImpl alloc] initWithBinaryMessenger:registrar.messenger
                                                        instanceManager:instanceManager]);
  SetUpFWFNSObjectHostApi(registrar.messenger,
                          [[FWFObjectHostApiImpl alloc] initWithInstanceManager:instanceManager]);
  SetUpFWFWKPreferencesHostApi(registrar.messenger, [[FWFPreferencesHostApiImpl alloc]
                                                        initWithInstanceManager:instanceManager]);
  SetUpFWFWKScriptMessageHandlerHostApi(
      registrar.messenger,
      [[FWFScriptMessageHandlerHostApiImpl alloc] initWithBinaryMessenger:registrar.messenger
                                                          instanceManager:instanceManager]);
  SetUpFWFUIScrollViewHostApi(registrar.messenger, [[FWFScrollViewHostApiImpl alloc]
                                                       initWithInstanceManager:instanceManager]);
  SetUpFWFWKUIDelegateHostApi(registrar.messenger, [[FWFUIDelegateHostApiImpl alloc]
                                                       initWithBinaryMessenger:registrar.messenger
                                                               instanceManager:instanceManager]);
  SetUpFWFUIViewHostApi(registrar.messenger,
                        [[FWFUIViewHostApiImpl alloc] initWithInstanceManager:instanceManager]);
  SetUpFWFWKUserContentControllerHostApi(
      registrar.messenger,
      [[FWFUserContentControllerHostApiImpl alloc] initWithInstanceManager:instanceManager]);
  SetUpFWFWKWebsiteDataStoreHostApi(
      registrar.messenger,
      [[FWFWebsiteDataStoreHostApiImpl alloc] initWithInstanceManager:instanceManager]);
  SetUpFWFWKWebViewConfigurationHostApi(
      registrar.messenger,
      [[FWFWebViewConfigurationHostApiImpl alloc] initWithBinaryMessenger:registrar.messenger
                                                          instanceManager:instanceManager]);
  SetUpFWFWKWebViewHostApi(registrar.messenger, [[FWFWebViewHostApiImpl alloc]
                                                    initWithBinaryMessenger:registrar.messenger
                                                            instanceManager:instanceManager]);
  SetUpFWFNSUrlHostApi(registrar.messenger,
                       [[FWFURLHostApiImpl alloc] initWithBinaryMessenger:registrar.messenger
                                                          instanceManager:instanceManager]);

  SetUpFWFNSUrlCredentialHostApi(
      registrar.messenger,
      [[FWFURLCredentialHostApiImpl alloc] initWithBinaryMessenger:registrar.messenger
                                                   instanceManager:instanceManager]);

  FWFWebViewFactory *webviewFactory = [[FWFWebViewFactory alloc] initWithManager:instanceManager];
  [registrar registerViewFactory:webviewFactory withId:@"plugins.flutter.io/webview"];

  // InstanceManager is published so that a strong reference is maintained.
  [registrar publish:instanceManager];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  [registrar publish:[NSNull null]];
}
@end
