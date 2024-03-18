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

import 'package:flutter/widgets.dart';

import 'types.dart';

/// Configuration to use when creating a new [WebViewPlatformController].
///
/// The `autoMediaPlaybackPolicy` parameter must not be null.
class CreationParams {
  /// Constructs an instance to use when creating a new
  /// [WebViewPlatformController].
  ///
  /// The `autoMediaPlaybackPolicy` parameter must not be null.
  CreationParams({
    this.initialUrl,
    this.webSettings,
    this.javascriptChannelNames = const <String>{},
    this.userAgent,
    this.autoMediaPlaybackPolicy =
        AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
    this.backgroundColor,
    this.cookies = const <WebViewCookie>[],
  });

  /// The initialUrl to load in the webview.
  ///
  /// When null the webview will be created without loading any page.
  final String? initialUrl;

  /// The initial [WebSettings] for the new webview.
  ///
  /// This can later be updated with [WebViewPlatformController.updateSettings].
  final WebSettings? webSettings;

  /// The initial set of JavaScript channels that are configured for this webview.
  ///
  /// For each value in this set the platform's webview should make sure that a corresponding
  /// property with a postMessage method is set on `window`. For example for a JavaScript channel
  /// named `Foo` it should be possible for JavaScript code executing in the webview to do
  ///
  /// ```javascript
  /// Foo.postMessage('hello');
  /// ```
  // TODO(amirh): describe what should happen when postMessage is called once that code is migrated
  // to PlatformWebView.
  final Set<String> javascriptChannelNames;

  /// The value used for the HTTP User-Agent: request header.
  ///
  /// When null the platform's webview default is used for the User-Agent header.
  final String? userAgent;

  /// Which restrictions apply on automatic media playback.
  final AutoMediaPlaybackPolicy autoMediaPlaybackPolicy;

  /// The background color of the webview.
  ///
  /// When null the platform's webview default background color is used.
  final Color? backgroundColor;

  /// The initial set of cookies to set before the webview does its first load.
  final List<WebViewCookie> cookies;

  @override
  String toString() {
    return 'CreationParams(initialUrl: $initialUrl, settings: $webSettings, javascriptChannelNames: $javascriptChannelNames, UserAgent: $userAgent, backgroundColor: $backgroundColor, cookies: $cookies)';
  }
}
