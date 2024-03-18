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

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'webview_cookie_manager_test.mocks.dart';

@GenerateMocks(<Type>[PlatformWebViewCookieManager])
void main() {
  group('WebViewCookieManager', () {
    test('clearCookies', () async {
      final MockPlatformWebViewCookieManager mockPlatformWebViewCookieManager =
          MockPlatformWebViewCookieManager();
      when(mockPlatformWebViewCookieManager.clearCookies()).thenAnswer(
        (_) => Future<bool>.value(false),
      );

      final WebViewCookieManager cookieManager =
          WebViewCookieManager.fromPlatform(
        mockPlatformWebViewCookieManager,
      );

      await expectLater(cookieManager.clearCookies(), completion(false));
    });

    test('setCookie', () async {
      final MockPlatformWebViewCookieManager mockPlatformWebViewCookieManager =
          MockPlatformWebViewCookieManager();

      final WebViewCookieManager cookieManager =
          WebViewCookieManager.fromPlatform(
        mockPlatformWebViewCookieManager,
      );

      const WebViewCookie cookie = WebViewCookie(
        name: 'name',
        value: 'value',
        domain: 'domain',
      );

      await cookieManager.setCookie(cookie);

      final WebViewCookie capturedCookie = verify(
        mockPlatformWebViewCookieManager.setCookie(captureAny),
      ).captured.single as WebViewCookie;
      expect(capturedCookie, cookie);
    });
  });
}
