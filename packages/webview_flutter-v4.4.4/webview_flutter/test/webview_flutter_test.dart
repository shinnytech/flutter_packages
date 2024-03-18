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
import 'package:webview_flutter/webview_flutter.dart' as main_file;

void main() {
  group('webview_flutter', () {
    test('ensure webview_flutter.dart exports classes from platform interface',
        () {
      // ignore: unnecessary_statements
      main_file.JavaScriptConsoleMessage;
      // ignore: unnecessary_statements
      main_file.JavaScriptLogLevel;
      // ignore: unnecessary_statements
      main_file.JavaScriptMessage;
      // ignore: unnecessary_statements
      main_file.JavaScriptMode;
      // ignore: unnecessary_statements
      main_file.LoadRequestMethod;
      // ignore: unnecessary_statements
      main_file.NavigationDecision;
      // ignore: unnecessary_statements
      main_file.NavigationRequest;
      // ignore: unnecessary_statements
      main_file.NavigationRequestCallback;
      // ignore: unnecessary_statements
      main_file.PageEventCallback;
      // ignore: unnecessary_statements
      main_file.PlatformNavigationDelegateCreationParams;
      // ignore: unnecessary_statements
      main_file.PlatformWebViewControllerCreationParams;
      // ignore: unnecessary_statements
      main_file.PlatformWebViewCookieManagerCreationParams;
      // ignore: unnecessary_statements
      main_file.PlatformWebViewPermissionRequest;
      // ignore: unnecessary_statements
      main_file.PlatformWebViewWidgetCreationParams;
      // ignore: unnecessary_statements
      main_file.ProgressCallback;
      // ignore: unnecessary_statements
      main_file.WebViewPermissionResourceType;
      // ignore: unnecessary_statements
      main_file.WebResourceError;
      // ignore: unnecessary_statements
      main_file.WebResourceErrorCallback;
      // ignore: unnecessary_statements
      main_file.WebViewCookie;
      // ignore: unnecessary_statements
      main_file.WebResourceErrorType;
      // ignore: unnecessary_statements
      main_file.UrlChange;
    });
  });
}
