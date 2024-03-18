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
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WebWebViewWidget', () {
    testWidgets('build returns a HtmlElementView', (WidgetTester tester) async {
      final WebWebViewController controller =
          WebWebViewController(WebWebViewControllerCreationParams());

      final WebWebViewWidget widget = WebWebViewWidget(
        PlatformWebViewWidgetCreationParams(
          key: const Key('keyValue'),
          controller: controller,
        ),
      );

      await tester.pumpWidget(
        Builder(builder: (BuildContext context) => widget.build(context)),
      );

      expect(find.byType(HtmlElementView), findsOneWidget);
      expect(find.byKey(const Key('keyValue')), findsOneWidget);
    });
  });
}
