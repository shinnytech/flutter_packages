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
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'webview_platform_test.mocks.dart';

void main() {
  setUp(() {
    WebViewPlatform.instance = MockWebViewPlatformWithMixin();
  });

  test('Cannot be implemented with `implements`', () {
    const PlatformNavigationDelegateCreationParams params =
        PlatformNavigationDelegateCreationParams();
    when(WebViewPlatform.instance!.createPlatformNavigationDelegate(params))
        .thenReturn(ImplementsPlatformNavigationDelegate());

    expect(() {
      PlatformNavigationDelegate(params);
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
    const PlatformNavigationDelegateCreationParams params =
        PlatformNavigationDelegateCreationParams();
    when(WebViewPlatform.instance!.createPlatformNavigationDelegate(params))
        .thenReturn(ExtendsPlatformNavigationDelegate(params));

    expect(PlatformNavigationDelegate(params), isNotNull);
  });

  test('Can be mocked with `implements`', () {
    const PlatformNavigationDelegateCreationParams params =
        PlatformNavigationDelegateCreationParams();
    when(WebViewPlatform.instance!.createPlatformNavigationDelegate(params))
        .thenReturn(MockNavigationDelegate());

    expect(PlatformNavigationDelegate(params), isNotNull);
  });

  test(
      'Default implementation of setOnNavigationRequest should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnNavigationRequest(
          (NavigationRequest navigationRequest) => NavigationDecision.navigate),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of setOnPageStarted should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnPageStarted((String url) {}),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of setOnPageFinished should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnPageFinished((String url) {}),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of setOnHttpError should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnHttpError((HttpResponseError error) {}),
      throwsUnimplementedError,
    );
  });

  test(
      // ignore: lines_longer_than_80_chars
      'Default implementation of setOnProgress should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnProgress((int progress) {}),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of setOnWebResourceError should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnWebResourceError((WebResourceError error) {}),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of setOnUrlChange should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnUrlChange((UrlChange change) {}),
      throwsUnimplementedError,
    );
  });

  test(
      'Default implementation of setOnHttpAuthRequest should throw unimplemented error',
      () {
    final PlatformNavigationDelegate callbackDelegate =
        ExtendsPlatformNavigationDelegate(
            const PlatformNavigationDelegateCreationParams());

    expect(
      () => callbackDelegate.setOnHttpAuthRequest((HttpAuthRequest request) {}),
      throwsUnimplementedError,
    );
  });
}

class MockWebViewPlatformWithMixin extends MockWebViewPlatform
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin {}

class ImplementsPlatformNavigationDelegate
    implements PlatformNavigationDelegate {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockNavigationDelegate extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        PlatformNavigationDelegate {}

class ExtendsPlatformNavigationDelegate extends PlatformNavigationDelegate {
  ExtendsPlatformNavigationDelegate(super.params) : super.implementation();
}
