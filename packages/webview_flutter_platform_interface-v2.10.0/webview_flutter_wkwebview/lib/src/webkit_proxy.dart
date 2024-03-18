/*
 * Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'common/instance_manager.dart';
import 'foundation/foundation.dart';
import 'web_kit/web_kit.dart';

// This convenience method was added because Dart doesn't support constant
// function literals: https://github.com/dart-lang/language/issues/1048.
WKWebsiteDataStore _defaultWebsiteDataStore() =>
    WKWebsiteDataStore.defaultDataStore;

/// Handles constructing objects and calling static methods for the WebKit
/// native library.
///
/// This class provides dependency injection for the implementations of the
/// platform interface classes. Improving the ease of unit testing and/or
/// overriding the underlying WebKit classes.
///
/// By default each function calls the default constructor of the WebKit class
/// it intends to return.
class WebKitProxy {
  /// Constructs a [WebKitProxy].
  const WebKitProxy({
    this.createWebView = WKWebView.new,
    this.createWebViewConfiguration = WKWebViewConfiguration.new,
    this.createScriptMessageHandler = WKScriptMessageHandler.new,
    this.defaultWebsiteDataStore = _defaultWebsiteDataStore,
    this.createNavigationDelegate = WKNavigationDelegate.new,
    this.createUIDelegate = WKUIDelegate.new,
  });

  /// Constructs a [WKWebView].
  final WKWebView Function(
    WKWebViewConfiguration configuration, {
    void Function(
      String keyPath,
      NSObject object,
      Map<NSKeyValueChangeKey, Object?> change,
    )? observeValue,
    InstanceManager? instanceManager,
  }) createWebView;

  /// Constructs a [WKWebViewConfiguration].
  final WKWebViewConfiguration Function({
    InstanceManager? instanceManager,
  }) createWebViewConfiguration;

  /// Constructs a [WKScriptMessageHandler].
  final WKScriptMessageHandler Function({
    required void Function(
      WKUserContentController userContentController,
      WKScriptMessage message,
    ) didReceiveScriptMessage,
  }) createScriptMessageHandler;

  /// The default [WKWebsiteDataStore].
  final WKWebsiteDataStore Function() defaultWebsiteDataStore;

  /// Constructs a [WKNavigationDelegate].
  final WKNavigationDelegate Function({
    void Function(WKWebView webView, String? url)? didFinishNavigation,
    void Function(WKWebView webView, String? url)?
        didStartProvisionalNavigation,
    Future<WKNavigationActionPolicy> Function(
      WKWebView webView,
      WKNavigationAction navigationAction,
    )? decidePolicyForNavigationAction,
    void Function(WKWebView webView, NSError error)? didFailNavigation,
    void Function(WKWebView webView, NSError error)?
        didFailProvisionalNavigation,
    void Function(WKWebView webView)? webViewWebContentProcessDidTerminate,
    void Function(
      WKWebView webView,
      NSUrlAuthenticationChallenge challenge,
      void Function(
        NSUrlSessionAuthChallengeDisposition disposition,
        NSUrlCredential? credential,
      ) completionHandler,
    )? didReceiveAuthenticationChallenge,
  }) createNavigationDelegate;

  /// Constructs a [WKUIDelegate].
  final WKUIDelegate Function({
    void Function(
      WKWebView webView,
      WKWebViewConfiguration configuration,
      WKNavigationAction navigationAction,
    )? onCreateWebView,
    Future<WKPermissionDecision> Function(
      WKUIDelegate instance,
      WKWebView webView,
      WKSecurityOrigin origin,
      WKFrameInfo frame,
      WKMediaCaptureType type,
    )? requestMediaCapturePermission,
    Future<void> Function(
      String message,
      WKFrameInfo frame,
    )? runJavaScriptAlertDialog,
    Future<bool> Function(
      String message,
      WKFrameInfo frame,
    )? runJavaScriptConfirmDialog,
    Future<String> Function(
      String prompt,
      String defaultText,
      WKFrameInfo frame,
    )? runJavaScriptTextInputDialog,
    InstanceManager? instanceManager,
  }) createUIDelegate;
}
