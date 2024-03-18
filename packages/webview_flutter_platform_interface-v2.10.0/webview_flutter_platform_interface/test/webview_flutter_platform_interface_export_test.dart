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

// ignore_for_file: unnecessary_statements

import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart'
    as main_file;

void main() {
  test(
    'ensures webview_flutter_platform_interface.dart exports classes in types directory',
    () {
      main_file.JavaScriptConsoleMessage;
      main_file.JavaScriptLogLevel;
      main_file.JavaScriptMessage;
      main_file.JavaScriptMode;
      main_file.LoadRequestMethod;
      main_file.NavigationDecision;
      main_file.NavigationRequest;
      main_file.NavigationRequestCallback;
      main_file.PageEventCallback;
      main_file.PlatformNavigationDelegateCreationParams;
      main_file.PlatformWebViewControllerCreationParams;
      main_file.PlatformWebViewCookieManagerCreationParams;
      main_file.PlatformWebViewPermissionRequest;
      main_file.PlatformWebViewWidgetCreationParams;
      main_file.ProgressCallback;
      main_file.WebViewPermissionResourceType;
      main_file.WebResourceRequest;
      main_file.WebResourceResponse;
      main_file.WebResourceError;
      main_file.WebResourceErrorCallback;
      main_file.WebViewCookie;
      main_file.WebResourceErrorType;
      main_file.UrlChange;
    },
  );
}
