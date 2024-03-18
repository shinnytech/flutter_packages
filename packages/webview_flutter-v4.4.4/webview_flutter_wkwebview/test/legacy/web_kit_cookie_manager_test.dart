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
import 'package:webview_flutter_platform_interface/src/webview_flutter_platform_interface_legacy.dart';
import 'package:webview_flutter_wkwebview/src/foundation/foundation.dart';
import 'package:webview_flutter_wkwebview/src/legacy/wkwebview_cookie_manager.dart';
import 'package:webview_flutter_wkwebview/src/web_kit/web_kit.dart';

import 'web_kit_cookie_manager_test.mocks.dart';

@GenerateMocks(<Type>[
  WKHttpCookieStore,
  WKWebsiteDataStore,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WebKitWebViewWidget', () {
    late MockWKWebsiteDataStore mockWebsiteDataStore;
    late MockWKHttpCookieStore mockWKHttpCookieStore;

    late WKWebViewCookieManager cookieManager;

    setUp(() {
      mockWebsiteDataStore = MockWKWebsiteDataStore();
      mockWKHttpCookieStore = MockWKHttpCookieStore();
      when(mockWebsiteDataStore.httpCookieStore)
          .thenReturn(mockWKHttpCookieStore);

      cookieManager =
          WKWebViewCookieManager(websiteDataStore: mockWebsiteDataStore);
    });

    test('clearCookies', () async {
      when(mockWebsiteDataStore.removeDataOfTypes(
              <WKWebsiteDataType>{WKWebsiteDataType.cookies}, any))
          .thenAnswer((_) => Future<bool>.value(true));
      expect(cookieManager.clearCookies(), completion(true));

      when(mockWebsiteDataStore.removeDataOfTypes(
              <WKWebsiteDataType>{WKWebsiteDataType.cookies}, any))
          .thenAnswer((_) => Future<bool>.value(false));
      expect(cookieManager.clearCookies(), completion(false));
    });

    test('setCookie', () async {
      await cookieManager.setCookie(
        const WebViewCookie(name: 'a', value: 'b', domain: 'c', path: 'd'),
      );

      final NSHttpCookie cookie =
          verify(mockWKHttpCookieStore.setCookie(captureAny)).captured.single
              as NSHttpCookie;
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
      expect(
        () => cookieManager.setCookie(
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
