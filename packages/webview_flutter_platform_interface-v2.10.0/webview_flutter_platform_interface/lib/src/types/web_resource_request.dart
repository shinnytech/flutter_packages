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

/// Defines the parameters of the web resource request from the associated request.
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
/// This example demonstrates how to extend the [WebResourceRequest] to
/// provide additional platform specific parameters.
///
/// When extending [WebResourceRequest] additional parameters should always
/// accept `null` or have a default value to prevent breaking changes.
///
/// ```dart
/// class AndroidWebResourceRequest extends WebResourceRequest {
///   WebResourceRequest._({
///     required WebResourceRequest request,
///   }) : super(
///     uri: request.uri,
///   );
///
///   factory AndroidWebResourceRequest.fromWebResourceRequest(
///     WebResourceRequest request, {
///     Map<String, String> headers,
///   }) {
///     return AndroidWebResourceRequest._(request, headers: headers);
///   }
///
///   final Map<String, String> headers;
/// }
/// ```
@immutable
class WebResourceRequest {
  /// Used by the platform implementation to create a new [WebResourceRequest].
  const WebResourceRequest({required this.uri});

  /// URI for the request.
  final Uri uri;
}
