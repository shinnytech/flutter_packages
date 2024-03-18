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
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'webview_platform_test.mocks.dart';

@GenerateMocks(<Type>[WebViewPlatform])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Default instance WebViewPlatform instance should be null', () {
    expect(WebViewPlatform.instance, isNull);
  });

  // This test can only run while `WebViewPlatform.instance` is still null.
  test(
      'Interface classes throw assertion error when `WebViewPlatform.instance` is null',
      () {
    expect(
      () => PlatformNavigationDelegate(
        const PlatformNavigationDelegateCreationParams(),
      ),
      throwsA(isA<AssertionError>().having(
        (AssertionError error) => error.message,
        'message',
        'A platform implementation for `webview_flutter` has not been set. Please '
            'ensure that an implementation of `WebViewPlatform` has been set to '
            '`WebViewPlatform.instance` before use. For unit testing, '
            '`WebViewPlatform.instance` can be set with your own test implementation.',
      )),
    );

    expect(
      () => PlatformWebViewController(
        const PlatformWebViewControllerCreationParams(),
      ),
      throwsA(isA<AssertionError>().having(
        (AssertionError error) => error.message,
        'message',
        'A platform implementation for `webview_flutter` has not been set. Please '
            'ensure that an implementation of `WebViewPlatform` has been set to '
            '`WebViewPlatform.instance` before use. For unit testing, '
            '`WebViewPlatform.instance` can be set with your own test implementation.',
      )),
    );

    expect(
      () => PlatformWebViewCookieManager(
        const PlatformWebViewCookieManagerCreationParams(),
      ),
      throwsA(isA<AssertionError>().having(
        (AssertionError error) => error.message,
        'message',
        'A platform implementation for `webview_flutter` has not been set. Please '
            'ensure that an implementation of `WebViewPlatform` has been set to '
            '`WebViewPlatform.instance` before use. For unit testing, '
            '`WebViewPlatform.instance` can be set with your own test implementation.',
      )),
    );

    expect(
      () => PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(
          controller: MockWebViewControllerDelegate(),
        ),
      ),
      throwsA(isA<AssertionError>().having(
        (AssertionError error) => error.message,
        'message',
        'A platform implementation for `webview_flutter` has not been set. Please '
            'ensure that an implementation of `WebViewPlatform` has been set to '
            '`WebViewPlatform.instance` before use. For unit testing, '
            '`WebViewPlatform.instance` can be set with your own test implementation.',
      )),
    );
  });

  test('Cannot be implemented with `implements`', () {
    expect(() {
      WebViewPlatform.instance = ImplementsWebViewPlatform();
      // In versions of `package:plugin_platform_interface` prior to fixing
      // https://github.com/flutter/flutter/issues/109339, an attempt to
      // implement a platform interface using `implements` would sometimes throw
      // a `NoSuchMethodError` and other times throw an `AssertionError`.  After
      // the issue is fixed, an `AssertionError` will always be thrown.  For the
      // purpose of this test, we don't really care what exception is thrown, so
      // just allow any exception.
    }, throwsA(anything));
  });

  test('Can be extended', () {
    WebViewPlatform.instance = ExtendsWebViewPlatform();
  });

  test('Can be mocked with `implements`', () {
    final MockWebViewPlatform mock = MockWebViewPlatformWithMixin();
    WebViewPlatform.instance = mock;
  });

  test(
      'Default implementation of createCookieManagerDelegate should throw unimplemented error',
      () {
    final WebViewPlatform webViewPlatform = ExtendsWebViewPlatform();

    expect(
      () => webViewPlatform.createPlatformCookieManager(
          const PlatformWebViewCookieManagerCreationParams()),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of createNavigationCallbackHandlerDelegate should throw unimplemented error',
      () {
    final WebViewPlatform webViewPlatform = ExtendsWebViewPlatform();

    expect(
      () => webViewPlatform.createPlatformNavigationDelegate(
          const PlatformNavigationDelegateCreationParams()),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of createWebViewControllerDelegate should throw unimplemented error',
      () {
    final WebViewPlatform webViewPlatform = ExtendsWebViewPlatform();

    expect(
      () => webViewPlatform.createPlatformWebViewController(
          const PlatformWebViewControllerCreationParams()),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of createWebViewWidgetDelegate should throw unimplemented error',
      () {
    final WebViewPlatform webViewPlatform = ExtendsWebViewPlatform();
    final MockWebViewControllerDelegate controller =
        MockWebViewControllerDelegate();

    expect(
      () => webViewPlatform.createPlatformWebViewWidget(
          PlatformWebViewWidgetCreationParams(controller: controller)),
      throwsUnimplementedError,
    );
  });
}

class ImplementsWebViewPlatform implements WebViewPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockWebViewPlatformWithMixin extends MockWebViewPlatform
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin {}

class ExtendsWebViewPlatform extends WebViewPlatform {}

class MockWebViewControllerDelegate extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        PlatformWebViewController {}
