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

#import "FWFUserContentControllerHostApi.h"
#import "FWFDataConverters.h"
#import "FWFWebViewConfigurationHostApi.h"

@interface FWFUserContentControllerHostApiImpl ()
// InstanceManager must be weak to prevent a circular reference with the object it stores.
@property(nonatomic, weak) FWFInstanceManager *instanceManager;
@end

@implementation FWFUserContentControllerHostApiImpl
- (instancetype)initWithInstanceManager:(FWFInstanceManager *)instanceManager {
  self = [self init];
  if (self) {
    _instanceManager = instanceManager;
  }
  return self;
}

- (WKUserContentController *)userContentControllerForIdentifier:(NSInteger)identifier {
  return (WKUserContentController *)[self.instanceManager instanceForIdentifier:identifier];
}

- (void)createFromWebViewConfigurationWithIdentifier:(NSInteger)identifier
                             configurationIdentifier:(NSInteger)configurationIdentifier
                                               error:(FlutterError *_Nullable *_Nonnull)error {
  WKWebViewConfiguration *configuration = (WKWebViewConfiguration *)[self.instanceManager
      instanceForIdentifier:configurationIdentifier];
  [self.instanceManager addDartCreatedInstance:configuration.userContentController
                                withIdentifier:identifier];
}

- (void)addScriptMessageHandlerForControllerWithIdentifier:(NSInteger)identifier
                                         handlerIdentifier:(NSInteger)handler
                                                    ofName:(nonnull NSString *)name
                                                     error:
                                                         (FlutterError *_Nullable *_Nonnull)error {
  [[self userContentControllerForIdentifier:identifier]
      addScriptMessageHandler:(id<WKScriptMessageHandler>)[self.instanceManager
                                  instanceForIdentifier:handler]
                         name:name];
}

- (void)removeScriptMessageHandlerForControllerWithIdentifier:(NSInteger)identifier
                                                         name:(nonnull NSString *)name
                                                        error:(FlutterError *_Nullable *_Nonnull)
                                                                  error {
  [[self userContentControllerForIdentifier:identifier] removeScriptMessageHandlerForName:name];
}

- (void)removeAllScriptMessageHandlersForControllerWithIdentifier:(NSInteger)identifier
                                                            error:
                                                                (FlutterError *_Nullable *_Nonnull)
                                                                    error {
  if (@available(iOS 14.0, *)) {
    [[self userContentControllerForIdentifier:identifier] removeAllScriptMessageHandlers];
  } else {
    *error = [FlutterError
        errorWithCode:@"FWFUnsupportedVersionError"
              message:@"removeAllScriptMessageHandlers is only supported on versions 14+."
              details:nil];
  }
}

- (void)addUserScriptForControllerWithIdentifier:(NSInteger)identifier
                                      userScript:(nonnull FWFWKUserScriptData *)userScript
                                           error:(FlutterError *_Nullable *_Nonnull)error {
  [[self userContentControllerForIdentifier:identifier]
      addUserScript:FWFNativeWKUserScriptFromScriptData(userScript)];
}

- (void)removeAllUserScriptsForControllerWithIdentifier:(NSInteger)identifier
                                                  error:(FlutterError *_Nullable *_Nonnull)error {
  [[self userContentControllerForIdentifier:identifier] removeAllUserScripts];
}

@end
