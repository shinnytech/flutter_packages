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
import 'package:webview_flutter_android/src/android_webview.dart'
    as android_webview;
import 'package:webview_flutter_android/src/legacy/webview_android_cookie_manager.dart';
import 'package:webview_flutter_platform_interface/src/webview_flutter_platform_interface_legacy.dart';

import 'webview_android_cookie_manager_test.mocks.dart';

@GenerateMocks(<Type>[android_webview.CookieManager])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('clearCookies should call android_webview.clearCookies', () {
    final MockCookieManager mockCookieManager = MockCookieManager();
    when(mockCookieManager.removeAllCookies())
        .thenAnswer((_) => Future<bool>.value(true));
    WebViewAndroidCookieManager(
      cookieManager: mockCookieManager,
    ).clearCookies();
    verify(mockCookieManager.removeAllCookies());
  });

  test('setCookie should throw ArgumentError for cookie with invalid path', () {
    expect(
      () => WebViewAndroidCookieManager(cookieManager: MockCookieManager())
          .setCookie(const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'flutter.dev',
        path: 'invalid;path',
      )),
      throwsA(const TypeMatcher<ArgumentError>()),
    );
  });

  test(
      'setCookie should call android_webview.csetCookie with properly formatted cookie value',
      () {
    final MockCookieManager mockCookieManager = MockCookieManager();
    WebViewAndroidCookieManager(cookieManager: mockCookieManager)
        .setCookie(const WebViewCookie(
      name: 'foo&',
      value: 'bar@',
      domain: 'flutter.dev',
    ));
    verify(mockCookieManager.setCookie('flutter.dev', 'foo%26=bar%40; path=/'));
  });
}
