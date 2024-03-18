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
import 'package:webview_flutter_android/src/android_webview_api_impls.dart';
import 'package:webview_flutter_android/src/instance_manager.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'android_webview_cookie_manager_test.mocks.dart';
import 'test_android_webview.g.dart';

@GenerateMocks(<Type>[
  android_webview.CookieManager,
  AndroidWebViewController,
  TestInstanceManagerHostApi,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mocks the call to clear the native InstanceManager.
  TestInstanceManagerHostApi.setup(MockTestInstanceManagerHostApi());

  test('clearCookies should call android_webview.clearCookies', () async {
    final android_webview.CookieManager mockCookieManager = MockCookieManager();

    when(mockCookieManager.removeAllCookies())
        .thenAnswer((_) => Future<bool>.value(true));

    final AndroidWebViewCookieManagerCreationParams params =
        AndroidWebViewCookieManagerCreationParams
            .fromPlatformWebViewCookieManagerCreationParams(
                const PlatformWebViewCookieManagerCreationParams());

    final bool hasClearedCookies = await AndroidWebViewCookieManager(params,
            cookieManager: mockCookieManager)
        .clearCookies();

    expect(hasClearedCookies, true);
    verify(mockCookieManager.removeAllCookies());
  });

  test('setCookie should throw ArgumentError for cookie with invalid path', () {
    final AndroidWebViewCookieManagerCreationParams params =
        AndroidWebViewCookieManagerCreationParams
            .fromPlatformWebViewCookieManagerCreationParams(
                const PlatformWebViewCookieManagerCreationParams());

    final AndroidWebViewCookieManager androidCookieManager =
        AndroidWebViewCookieManager(params, cookieManager: MockCookieManager());

    expect(
      () => androidCookieManager.setCookie(const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'flutter.dev',
        path: 'invalid;path',
      )),
      throwsA(const TypeMatcher<ArgumentError>()),
    );
  });

  test(
      'setCookie should call android_webview.setCookie with properly formatted cookie value',
      () {
    final android_webview.CookieManager mockCookieManager = MockCookieManager();
    final AndroidWebViewCookieManagerCreationParams params =
        AndroidWebViewCookieManagerCreationParams
            .fromPlatformWebViewCookieManagerCreationParams(
                const PlatformWebViewCookieManagerCreationParams());

    AndroidWebViewCookieManager(params, cookieManager: mockCookieManager)
        .setCookie(const WebViewCookie(
      name: 'foo&',
      value: 'bar@',
      domain: 'flutter.dev',
    ));

    verify(mockCookieManager.setCookie(
      'flutter.dev',
      'foo%26=bar%40; path=/',
    ));
  });

  test('setAcceptThirdPartyCookies', () async {
    final MockAndroidWebViewController mockController =
        MockAndroidWebViewController();

    final InstanceManager instanceManager =
        InstanceManager(onWeakReferenceRemoved: (_) {});
    android_webview.WebView.api = WebViewHostApiImpl(
      instanceManager: instanceManager,
    );
    final android_webview.WebView webView = android_webview.WebView.detached(
      instanceManager: instanceManager,
    );

    const int webViewIdentifier = 4;
    instanceManager.addHostCreatedInstance(webView, webViewIdentifier);

    when(mockController.webViewIdentifier).thenReturn(webViewIdentifier);

    final AndroidWebViewCookieManagerCreationParams params =
        AndroidWebViewCookieManagerCreationParams
            .fromPlatformWebViewCookieManagerCreationParams(
                const PlatformWebViewCookieManagerCreationParams());

    final android_webview.CookieManager mockCookieManager = MockCookieManager();

    await AndroidWebViewCookieManager(
      params,
      cookieManager: mockCookieManager,
    ).setAcceptThirdPartyCookies(mockController, false);

    verify(mockCookieManager.setAcceptThirdPartyCookies(webView, false));

    android_webview.WebView.api = WebViewHostApiImpl();
  });
}
