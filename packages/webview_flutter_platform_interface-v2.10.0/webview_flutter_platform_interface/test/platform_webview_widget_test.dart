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
    final MockWebViewControllerDelegate controller =
        MockWebViewControllerDelegate();
    final PlatformWebViewWidgetCreationParams params =
        PlatformWebViewWidgetCreationParams(controller: controller);
    when(WebViewPlatform.instance!.createPlatformWebViewWidget(params))
        .thenReturn(ImplementsWebViewWidgetDelegate());

    expect(() {
      PlatformWebViewWidget(params);
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
    final MockWebViewControllerDelegate controller =
        MockWebViewControllerDelegate();
    final PlatformWebViewWidgetCreationParams params =
        PlatformWebViewWidgetCreationParams(controller: controller);
    when(WebViewPlatform.instance!.createPlatformWebViewWidget(params))
        .thenReturn(ExtendsWebViewWidgetDelegate(params));

    expect(PlatformWebViewWidget(params), isNotNull);
  });

  test('Can be mocked with `implements`', () {
    final MockWebViewControllerDelegate controller =
        MockWebViewControllerDelegate();
    final PlatformWebViewWidgetCreationParams params =
        PlatformWebViewWidgetCreationParams(controller: controller);
    when(WebViewPlatform.instance!.createPlatformWebViewWidget(params))
        .thenReturn(MockWebViewWidgetDelegate());

    expect(PlatformWebViewWidget(params), isNotNull);
  });
}

class MockWebViewPlatformWithMixin extends MockWebViewPlatform
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin {}

class ImplementsWebViewWidgetDelegate implements PlatformWebViewWidget {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockWebViewWidgetDelegate extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        PlatformWebViewWidget {}

class ExtendsWebViewWidgetDelegate extends PlatformWebViewWidget {
  ExtendsWebViewWidgetDelegate(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError(
        'build is not implemented for ExtendedWebViewWidgetDelegate.');
  }
}

class MockWebViewControllerDelegate extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        PlatformWebViewController {}
