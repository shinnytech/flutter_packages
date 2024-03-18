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

import 'package:flutter/foundation.dart';

/// A cookie that can be set globally for all web views using [WebViewCookieManagerPlatform].
@immutable
class WebViewCookie {
  /// Creates a new [WebViewCookieDelegate]
  const WebViewCookie({
    required this.name,
    required this.value,
    required this.domain,
    this.path = '/',
  });

  /// The cookie-name of the cookie.
  ///
  /// Its value should match "cookie-name" in RFC6265bis:
  /// https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-02#section-4.1.1
  final String name;

  /// The cookie-value of the cookie.
  ///
  /// Its value should match "cookie-value" in RFC6265bis:
  /// https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-02#section-4.1.1
  final String value;

  /// The domain-value of the cookie.
  ///
  /// Its value should match "domain-value" in RFC6265bis:
  /// https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-02#section-4.1.1
  final String domain;

  /// The path-value of the cookie, set to `/` by default.
  ///
  /// Its value should match "path-value" in RFC6265bis:
  /// https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-02#section-4.1.1
  final String path;
}
