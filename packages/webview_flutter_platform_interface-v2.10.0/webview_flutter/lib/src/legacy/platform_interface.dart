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

/// Re-export the classes from the webview_flutter_platform_interface through
/// the `platform_interface.dart` file so we don't accidentally break any
/// non-endorsed existing implementations of the interface.
library;

export 'package:webview_flutter_platform_interface/src/webview_flutter_platform_interface_legacy.dart'
    show
        AutoMediaPlaybackPolicy,
        CreationParams,
        JavascriptChannel,
        JavascriptChannelRegistry,
        JavascriptMessage,
        JavascriptMessageHandler,
        JavascriptMode,
        WebResourceError,
        WebResourceErrorType,
        WebSetting,
        WebSettings,
        WebViewCookie,
        WebViewPlatform,
        WebViewPlatformCallbacksHandler,
        WebViewPlatformController,
        WebViewPlatformCreatedCallback,
        WebViewRequest,
        WebViewRequestMethod;
