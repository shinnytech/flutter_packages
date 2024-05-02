/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import 'ohos_webview.dart' as ohos_webview;

/// Handles constructing objects and calling static methods for the Ohos
/// WebView native library.
///
/// This class provides dependency injection for the implementations of the
/// platform interface classes. Improving the ease of unit testing and/or
/// overriding the underlying Ohos WebView classes.
///
/// By default each function calls the default constructor of the WebView class
/// it intends to return.
class OhosWebViewProxy {
  /// Constructs a [OhosWebViewProxy].
  const OhosWebViewProxy({
    this.createOhosWebView = ohos_webview.WebView.new,
    this.createOhosWebChromeClient = ohos_webview.WebChromeClient.new,
    this.createOhosWebViewClient = ohos_webview.WebViewClient.new,
    this.createFlutterAssetManager = ohos_webview.FlutterAssetManager.new,
    this.createJavaScriptChannel = ohos_webview.JavaScriptChannel.new,
    this.createDownloadListener = ohos_webview.DownloadListener.new,
  });

  /// Constructs a [ohos_webview.WebView].
  final ohos_webview.WebView Function() createOhosWebView;

  /// Constructs a [ohos_webview.WebChromeClient].
  final ohos_webview.WebChromeClient Function({
    void Function(ohos_webview.WebView webView, int progress)?
        onProgressChanged,
    Future<List<String>> Function(
      ohos_webview.WebView webView,
      ohos_webview.FileChooserParams params,
    )? onShowFileChooser,
    void Function(
      ohos_webview.WebChromeClient instance,
      ohos_webview.PermissionRequest request,
    )? onPermissionRequest,
    Future<void> Function(String origin,
            ohos_webview.GeolocationPermissionsCallback callback)?
        onGeolocationPermissionsShowPrompt,
    void Function(ohos_webview.WebChromeClient instance)?
        onGeolocationPermissionsHidePrompt,
    Future<void> Function(String url, String message)? onJsAlert,
    Future<bool> Function(String url, String message)? onJsConfirm,
    Future<String> Function(String url, String message, String defaultValue)?
        onJsPrompt,
  }) createOhosWebChromeClient;

  /// Constructs a [ohos_webview.WebViewClient].
  final ohos_webview.WebViewClient Function({
    void Function(ohos_webview.WebView webView, String url)? onPageStarted,
    void Function(ohos_webview.WebView webView, String url)? onPageFinished,
    void Function(
      ohos_webview.WebView webView,
      ohos_webview.WebResourceRequest request,
      ohos_webview.WebResourceError error,
    )? onReceivedRequestError,
    @Deprecated('Only called on Ohos version < 23.')
    void Function(
      ohos_webview.WebView webView,
      int errorCode,
      String description,
      String failingUrl,
    )? onReceivedError,
    void Function(
      ohos_webview.WebView webView,
      ohos_webview.WebResourceRequest request,
    )? requestLoading,
    void Function(ohos_webview.WebView webView, String url)? urlLoading,
    void Function(ohos_webview.WebView webView, String url, bool isReload)?
        doUpdateVisitedHistory,
  }) createOhosWebViewClient;

  /// Constructs a [ohos_webview.FlutterAssetManager].
  final ohos_webview.FlutterAssetManager Function() createFlutterAssetManager;

  /// Constructs a [ohos_webview.JavaScriptChannel].
  final ohos_webview.JavaScriptChannel Function(
    String channelName, {
    required void Function(String) postMessage,
  }) createJavaScriptChannel;

  /// Constructs a [ohos_webview.DownloadListener].
  final ohos_webview.DownloadListener Function({
    required void Function(
      String url,
      String userAgent,
      String contentDisposition,
      String mimetype,
      int contentLength,
    ) onDownloadStart,
  }) createDownloadListener;

  /// Enables debugging of web contents (HTML / CSS / JavaScript) loaded into any WebViews of this application.
  ///
  /// This flag can be enabled in order to facilitate debugging of web layouts
  /// and JavaScript code running inside WebViews. Please refer to
  /// [ohos_webview.WebView] documentation for the debugging guide. The
  /// default is false.
  ///
  /// See [ohos_webview.WebView].setWebContentsDebuggingEnabled.
  Future<void> setWebContentsDebuggingEnabled(bool enabled) {
    return ohos_webview.WebView.setWebContentsDebuggingEnabled(enabled);
  }
}
