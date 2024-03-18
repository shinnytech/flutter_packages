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
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'webview_widget_test.mocks.dart';

@GenerateMocks(<Type>[PlatformWebViewController, PlatformWebViewWidget])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WebViewWidget', () {
    testWidgets('build', (WidgetTester tester) async {
      final MockPlatformWebViewWidget mockPlatformWebViewWidget =
          MockPlatformWebViewWidget();
      when(mockPlatformWebViewWidget.build(any)).thenReturn(Container());

      await tester.pumpWidget(WebViewWidget.fromPlatform(
        platform: mockPlatformWebViewWidget,
      ));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets(
        'constructor parameters are correctly passed to creation params',
        (WidgetTester tester) async {
      WebViewPlatform.instance = TestWebViewPlatform();

      final MockPlatformWebViewController mockPlatformWebViewController =
          MockPlatformWebViewController();
      final WebViewController webViewController =
          WebViewController.fromPlatform(
        mockPlatformWebViewController,
      );

      final WebViewWidget webViewWidget = WebViewWidget(
        key: GlobalKey(),
        controller: webViewController,
        layoutDirection: TextDirection.rtl,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
      );

      // The key passed to the default constructor is used by the super class
      // and not passed to the platform implementation.
      expect(webViewWidget.platform.params.key, isNull);
      expect(
        webViewWidget.platform.params.controller,
        webViewController.platform,
      );
      expect(webViewWidget.platform.params.layoutDirection, TextDirection.rtl);
      expect(
        webViewWidget.platform.params.gestureRecognizers.isNotEmpty,
        isTrue,
      );
    });
  });
}

class TestWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return TestPlatformWebViewWidget(params);
  }
}

class TestPlatformWebViewWidget extends PlatformWebViewWidget {
  TestPlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
