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

/// A message that was sent by JavaScript code running in a [WebView].
///
/// Platform specific implementations can add additional fields by extending
/// this class and providing a factory method that takes the
/// [JavaScriptMessage] as a parameter.
///
/// {@tool sample}
/// This example demonstrates how to extend the [JavaScriptMessage] to
/// provide additional platform specific parameters.
///
/// When extending [JavaScriptMessage] additional parameters should always
/// accept `null` or have a default value to prevent breaking changes.
///
/// ```dart
/// @immutable
/// class WKWebViewScriptMessage extends JavaScriptMessage {
///   WKWebViewScriptMessage._(
///     JavaScriptMessage javaScriptMessage,
///     this.extraData,
///   ) : super(javaScriptMessage.message);
///
///   factory WKWebViewScriptMessage.fromJavaScripMessage(
///     JavaScriptMessage javaScripMessage, {
///     String? extraData,
///   }) {
///     return WKWebViewScriptMessage._(
///       javaScriptMessage,
///       extraData: extraData,
///     );
///   }
///
///   final String? extraData;
/// }
/// ```
/// {@end-tool}
@immutable
class JavaScriptMessage {
  /// Creates a new JavaScript message object.
  const JavaScriptMessage({
    required this.message,
  });

  /// The contents of the message that was sent by the JavaScript code.
  final String message;
}
