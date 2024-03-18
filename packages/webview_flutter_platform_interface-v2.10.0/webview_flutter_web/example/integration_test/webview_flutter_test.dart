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

import 'dart:async';
import 'dart:html' as html;
import 'dart:io';

// FIX (dit): Remove these integration tests, or make them run. They currently never fail.
// (They won't run because they use `dart:io`. If you remove all `dart:io` bits from
// this file, they start failing with `fail()`, for example.)

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
  unawaited(server.forEach((HttpRequest request) {
    if (request.uri.path == '/hello.txt') {
      request.response.writeln('Hello, world.');
    } else {
      fail('unexpected request: ${request.method} ${request.uri}');
    }
    request.response.close();
  }));
  final String prefixUrl = 'http://${server.address.address}:${server.port}';
  final String primaryUrl = '$prefixUrl/hello.txt';

  testWidgets('loadRequest', (WidgetTester tester) async {
    final WebWebViewController controller =
        WebWebViewController(const PlatformWebViewControllerCreationParams());
    await controller.loadRequest(
      LoadRequestParams(uri: Uri.parse(primaryUrl)),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(builder: (BuildContext context) {
          return WebWebViewWidget(
            PlatformWebViewWidgetCreationParams(controller: controller),
          ).build(context);
        }),
      ),
    );

    // Assert an iframe has been rendered to the DOM with the correct src attribute.
    final html.IFrameElement? element =
        html.document.querySelector('iframe') as html.IFrameElement?;
    expect(element, isNotNull);
    expect(element!.src, primaryUrl);
  });

  testWidgets('loadHtmlString', (WidgetTester tester) async {
    final WebWebViewController controller =
        WebWebViewController(const PlatformWebViewControllerCreationParams());
    await controller.loadHtmlString(
      'data:text/html;charset=utf-8,${Uri.encodeFull('test html')}',
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(builder: (BuildContext context) {
          return WebWebViewWidget(
            PlatformWebViewWidgetCreationParams(controller: controller),
          ).build(context);
        }),
      ),
    );

    // Assert an iframe has been rendered to the DOM with the correct src attribute.
    final html.IFrameElement? element =
        html.document.querySelector('iframe') as html.IFrameElement?;
    expect(element, isNotNull);
    expect(
      element!.src,
      'data:text/html;charset=utf-8,data:text/html;charset=utf-8,test%2520html',
    );
  });
}
