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
import 'package:webview_flutter_wkwebview/src/common/instance_manager.dart';
import 'package:webview_flutter_wkwebview/src/foundation/foundation.dart';
import 'package:webview_flutter_wkwebview/src/web_kit/web_kit.dart';
import 'package:webview_flutter_wkwebview/src/webkit_proxy.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'webkit_webview_widget_test.mocks.dart';

@GenerateMocks(<Type>[WKUIDelegate, WKWebViewConfiguration])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WebKitWebViewWidget', () {
    testWidgets('build', (WidgetTester tester) async {
      final InstanceManager testInstanceManager = InstanceManager(
        onWeakReferenceRemoved: (_) {},
      );

      final WebKitWebViewController controller =
          createTestWebViewController(testInstanceManager);

      final WebKitWebViewWidget widget = WebKitWebViewWidget(
        WebKitWebViewWidgetCreationParams(
          key: const Key('keyValue'),
          controller: controller,
          instanceManager: testInstanceManager,
        ),
      );

      await tester.pumpWidget(
        Builder(builder: (BuildContext context) => widget.build(context)),
      );

      expect(find.byType(UiKitView), findsOneWidget);
      expect(find.byKey(const Key('keyValue')), findsOneWidget);
    });

    testWidgets('Key of the PlatformView changes when the controller changes',
        (WidgetTester tester) async {
      final InstanceManager testInstanceManager = InstanceManager(
        onWeakReferenceRemoved: (_) {},
      );

      // Pump WebViewWidget with first controller.
      final WebKitWebViewController controller1 =
          createTestWebViewController(testInstanceManager);
      final WebKitWebViewWidget webViewWidget = WebKitWebViewWidget(
        WebKitWebViewWidgetCreationParams(
          controller: controller1,
          instanceManager: testInstanceManager,
        ),
      );

      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) => webViewWidget.build(context),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          ValueKey<WebKitWebViewWidgetCreationParams>(
            webViewWidget.params as WebKitWebViewWidgetCreationParams,
          ),
        ),
        findsOneWidget,
      );

      // Pump WebViewWidget with second controller.
      final WebKitWebViewController controller2 =
          createTestWebViewController(testInstanceManager);
      final WebKitWebViewWidget webViewWidget2 = WebKitWebViewWidget(
        WebKitWebViewWidgetCreationParams(
          controller: controller2,
          instanceManager: testInstanceManager,
        ),
      );

      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) => webViewWidget2.build(context),
        ),
      );
      await tester.pumpAndSettle();

      expect(webViewWidget.params != webViewWidget2.params, isTrue);
      expect(
        find.byKey(
          ValueKey<WebKitWebViewWidgetCreationParams>(
            webViewWidget.params as WebKitWebViewWidgetCreationParams,
          ),
        ),
        findsNothing,
      );
      expect(
        find.byKey(
          ValueKey<WebKitWebViewWidgetCreationParams>(
            webViewWidget2.params as WebKitWebViewWidgetCreationParams,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'Key of the PlatformView is the same when the creation params are equal',
        (WidgetTester tester) async {
      final InstanceManager testInstanceManager = InstanceManager(
        onWeakReferenceRemoved: (_) {},
      );

      final WebKitWebViewController controller =
          createTestWebViewController(testInstanceManager);

      final WebKitWebViewWidget webViewWidget = WebKitWebViewWidget(
        WebKitWebViewWidgetCreationParams(
          controller: controller,
          instanceManager: testInstanceManager,
        ),
      );

      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) => webViewWidget.build(context),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          ValueKey<WebKitWebViewWidgetCreationParams>(
            webViewWidget.params as WebKitWebViewWidgetCreationParams,
          ),
        ),
        findsOneWidget,
      );

      final WebKitWebViewWidget webViewWidget2 = WebKitWebViewWidget(
        WebKitWebViewWidgetCreationParams(
          controller: controller,
          instanceManager: testInstanceManager,
        ),
      );

      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) => webViewWidget2.build(context),
        ),
      );
      await tester.pumpAndSettle();

      // Can find the new widget with the key of the first widget.
      expect(
        find.byKey(
          ValueKey<WebKitWebViewWidgetCreationParams>(
            webViewWidget.params as WebKitWebViewWidgetCreationParams,
          ),
        ),
        findsOneWidget,
      );
    });
  });
}

WebKitWebViewController createTestWebViewController(
  InstanceManager testInstanceManager,
) {
  return WebKitWebViewController(
    WebKitWebViewControllerCreationParams(
      webKitProxy: WebKitProxy(createWebView: (
        WKWebViewConfiguration configuration, {
        void Function(
          String keyPath,
          NSObject object,
          Map<NSKeyValueChangeKey, Object?> change,
        )? observeValue,
        InstanceManager? instanceManager,
      }) {
        final WKWebView webView = WKWebView.detached(
          instanceManager: testInstanceManager,
        );
        testInstanceManager.addDartCreatedInstance(webView);
        return webView;
      }, createWebViewConfiguration: ({InstanceManager? instanceManager}) {
        return MockWKWebViewConfiguration();
      }, createUIDelegate: ({
        dynamic onCreateWebView,
        dynamic requestMediaCapturePermission,
        InstanceManager? instanceManager,
      }) {
        final MockWKUIDelegate mockWKUIDelegate = MockWKUIDelegate();
        when(mockWKUIDelegate.copy()).thenReturn(MockWKUIDelegate());

        testInstanceManager.addDartCreatedInstance(mockWKUIDelegate);
        return mockWKUIDelegate;
      }),
    ),
  );
}
