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
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'navigation_delegate_test.mocks.dart';

@GenerateMocks(<Type>[WebViewPlatform, PlatformNavigationDelegate])
void main() {
  group('NavigationDelegate', () {
    test('onNavigationRequest', () async {
      WebViewPlatform.instance = TestWebViewPlatform();

      NavigationDecision onNavigationRequest(NavigationRequest request) {
        return NavigationDecision.navigate;
      }

      final NavigationDelegate delegate = NavigationDelegate(
        onNavigationRequest: onNavigationRequest,
      );

      verify(delegate.platform.setOnNavigationRequest(onNavigationRequest));
    });

    test('onPageStarted', () async {
      WebViewPlatform.instance = TestWebViewPlatform();

      void onPageStarted(String url) {}

      final NavigationDelegate delegate = NavigationDelegate(
        onPageStarted: onPageStarted,
      );

      verify(delegate.platform.setOnPageStarted(onPageStarted));
    });

    test('onPageFinished', () async {
      WebViewPlatform.instance = TestWebViewPlatform();

      void onPageFinished(String url) {}

      final NavigationDelegate delegate = NavigationDelegate(
        onPageFinished: onPageFinished,
      );

      verify(delegate.platform.setOnPageFinished(onPageFinished));
    });

    test('onProgress', () async {
      WebViewPlatform.instance = TestWebViewPlatform();

      void onProgress(int progress) {}

      final NavigationDelegate delegate = NavigationDelegate(
        onProgress: onProgress,
      );

      verify(delegate.platform.setOnProgress(onProgress));
    });

    test('onWebResourceError', () async {
      WebViewPlatform.instance = TestWebViewPlatform();

      void onWebResourceError(WebResourceError error) {}

      final NavigationDelegate delegate = NavigationDelegate(
        onWebResourceError: onWebResourceError,
      );

      verify(delegate.platform.setOnWebResourceError(onWebResourceError));
    });

    test('onUrlChange', () async {
      WebViewPlatform.instance = TestWebViewPlatform();

      void onUrlChange(UrlChange change) {}

      final NavigationDelegate delegate = NavigationDelegate(
        onUrlChange: onUrlChange,
      );

      verify(delegate.platform.setOnUrlChange(onUrlChange));
    });
  });
}

class TestWebViewPlatform extends WebViewPlatform {
  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return TestMockPlatformNavigationDelegate();
  }
}

class TestMockPlatformNavigationDelegate extends MockPlatformNavigationDelegate
    with MockPlatformInterfaceMixin {}
