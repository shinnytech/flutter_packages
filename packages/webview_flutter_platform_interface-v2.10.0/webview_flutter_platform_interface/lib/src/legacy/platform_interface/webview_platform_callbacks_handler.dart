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

import 'dart:async';

import '../types/types.dart';

/// Interface for callbacks made by [WebViewPlatformController].
///
/// The webview plugin implements this class, and passes an instance to the [WebViewPlatformController].
/// [WebViewPlatformController] is notifying this handler on events that happened on the platform's webview.
abstract class WebViewPlatformCallbacksHandler {
  /// Invoked by [WebViewPlatformController] when a navigation request is pending.
  ///
  /// If true is returned the navigation is allowed, otherwise it is blocked.
  FutureOr<bool> onNavigationRequest(
      {required String url, required bool isForMainFrame});

  /// Invoked by [WebViewPlatformController] when a page has started loading.
  void onPageStarted(String url);

  /// Invoked by [WebViewPlatformController] when a page has finished loading.
  void onPageFinished(String url);

  /// Invoked by [WebViewPlatformController] when a page is loading.
  /// /// Only works when [WebSettings.hasProgressTracking] is set to `true`.
  void onProgress(int progress);

  /// Report web resource loading error to the host application.
  void onWebResourceError(WebResourceError error);
}
