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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/src/foundation/foundation.dart';
import 'package:webview_flutter_wkwebview/src/web_kit/web_kit.dart';
import 'package:webview_flutter_wkwebview/src/webkit_proxy.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'webkit_webview_cookie_manager_test.mocks.dart';

@GenerateMocks(<Type>[WKWebsiteDataStore, WKHttpCookieStore])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('WebKitWebViewCookieManager', () {
    test('clearCookies', () {
      final MockWKWebsiteDataStore mockWKWebsiteDataStore =
          MockWKWebsiteDataStore();

      final WebKitWebViewCookieManager manager = WebKitWebViewCookieManager(
        WebKitWebViewCookieManagerCreationParams(
          webKitProxy: WebKitProxy(
            defaultWebsiteDataStore: () => mockWKWebsiteDataStore,
          ),
        ),
      );

      when(
        mockWKWebsiteDataStore.removeDataOfTypes(
          <WKWebsiteDataType>{WKWebsiteDataType.cookies},
          any,
        ),
      ).thenAnswer((_) => Future<bool>.value(true));
      expect(manager.clearCookies(), completion(true));

      when(
        mockWKWebsiteDataStore.removeDataOfTypes(
          <WKWebsiteDataType>{WKWebsiteDataType.cookies},
          any,
        ),
      ).thenAnswer((_) => Future<bool>.value(false));
      expect(manager.clearCookies(), completion(false));
    });

    test('setCookie', () async {
      final MockWKWebsiteDataStore mockWKWebsiteDataStore =
          MockWKWebsiteDataStore();

      final MockWKHttpCookieStore mockCookieStore = MockWKHttpCookieStore();
      when(mockWKWebsiteDataStore.httpCookieStore).thenReturn(mockCookieStore);

      final WebKitWebViewCookieManager manager = WebKitWebViewCookieManager(
        WebKitWebViewCookieManagerCreationParams(
          webKitProxy: WebKitProxy(
            defaultWebsiteDataStore: () => mockWKWebsiteDataStore,
          ),
        ),
      );

      await manager.setCookie(
        const WebViewCookie(name: 'a', value: 'b', domain: 'c', path: 'd'),
      );

      final NSHttpCookie cookie = verify(mockCookieStore.setCookie(captureAny))
          .captured
          .single as NSHttpCookie;
      expect(
        cookie.properties,
        <NSHttpCookiePropertyKey, Object>{
          NSHttpCookiePropertyKey.name: 'a',
          NSHttpCookiePropertyKey.value: 'b',
          NSHttpCookiePropertyKey.domain: 'c',
          NSHttpCookiePropertyKey.path: 'd',
        },
      );
    });

    test('setCookie throws argument error with invalid path', () async {
      final MockWKWebsiteDataStore mockWKWebsiteDataStore =
          MockWKWebsiteDataStore();

      final MockWKHttpCookieStore mockCookieStore = MockWKHttpCookieStore();
      when(mockWKWebsiteDataStore.httpCookieStore).thenReturn(mockCookieStore);

      final WebKitWebViewCookieManager manager = WebKitWebViewCookieManager(
        WebKitWebViewCookieManagerCreationParams(
          webKitProxy: WebKitProxy(
            defaultWebsiteDataStore: () => mockWKWebsiteDataStore,
          ),
        ),
      );

      expect(
        () => manager.setCookie(
          WebViewCookie(
            name: 'a',
            value: 'b',
            domain: 'c',
            path: String.fromCharCode(0x1F),
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
