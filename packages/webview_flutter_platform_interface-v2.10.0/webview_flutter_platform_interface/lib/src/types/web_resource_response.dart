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

/// Contains information about the response for a request.
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
/// This example demonstrates how to extend the [WebResourceResponse] to
/// provide additional platform specific parameters.
///
/// When extending [WebResourceResponse] additional parameters should always
/// accept `null` or have a default value to prevent breaking changes.
///
/// ```dart
/// class AndroidWebResourceResponse extends WebResourceResponse {
///   WebResourceResponse._({
///     required WebResourceResponse response,
///   }) : super(
///     uri: response.uri,
///     statusCode: response.statusCode,
///     headers: response.headers,
///   );
///
///   factory AndroidWebResourceResponse.fromWebResourceResponse(
///     WebResourceResponse response, {
///     Uri? historyUrl,
///   }) {
///     return AndroidWebResourceResponse._(response, historyUrl: historyUrl);
///   }
///
///   final Uri? historyUrl;
/// }
/// ```
@immutable
class WebResourceResponse {
  /// Used by the platform implementation to create a new [WebResourceResponse].
  const WebResourceResponse({
    required this.uri,
    required this.statusCode,
    this.headers = const <String, String>{},
  });

  /// The URI that this response is associated with.
  final Uri? uri;

  /// The HTTP status code.
  final int statusCode;

  /// Headers for the request.
  final Map<String, String> headers;
}
