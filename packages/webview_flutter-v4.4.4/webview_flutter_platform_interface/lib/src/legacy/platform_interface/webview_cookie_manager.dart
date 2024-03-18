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

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../types/webview_cookie.dart';

/// Interface for a platform implementation of a cookie manager.
///
/// Platform implementations should extend this class rather than implement it as `webview_flutter`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [WebViewCookieManagerPlatform] methods.
abstract class WebViewCookieManagerPlatform extends PlatformInterface {
  /// Constructs a WebViewCookieManagerPlatform.
  WebViewCookieManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebViewCookieManagerPlatform? _instance;

  /// The instance of [WebViewCookieManagerPlatform] to use.
  static WebViewCookieManagerPlatform? get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [WebViewCookieManagerPlatform] when they register themselves.
  static set instance(WebViewCookieManagerPlatform? instance) {
    if (instance == null) {
      throw AssertionError(
          'Platform interfaces can only be set to a non-null instance');
    }
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Clears all cookies for all [WebView] instances.
  ///
  /// Returns true if cookies were present before clearing, else false.
  Future<bool> clearCookies() {
    throw UnimplementedError(
        'clearCookies is not implemented on the current platform');
  }

  /// Sets a cookie for all [WebView] instances.
  Future<void> setCookie(WebViewCookie cookie) {
    throw UnimplementedError(
        'setCookie is not implemented on the current platform');
  }
}
