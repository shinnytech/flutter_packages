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

import 'web_resource_request.dart';
import 'web_resource_response.dart';

/// Error returned in `PlatformNavigationDelegate.setOnHttpError` when an HTTP
/// response error has been received.
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
/// This example demonstrates how to extend the [HttpResponseError] to
/// provide additional platform specific parameters.
///
/// When extending [HttpResponseError] additional parameters should always
/// accept `null` or have a default value to prevent breaking changes.
///
/// ```dart
/// class IOSHttpResponseError extends HttpResponseError {
///   IOSHttpResponseError._(HttpResponseError error, {required this.domain})
///       : super(
///           statusCode: error.statusCode,
///         );
///
///   factory IOSHttpResponseError.fromHttpResponseError(
///     HttpResponseError error, {
///     required String? domain,
///   }) {
///     return IOSHttpResponseError._(error, domain: domain);
///   }
///
///   final String? domain;
/// }
/// ```
@immutable
class HttpResponseError {
  /// Used by the platform implementation to create a new [HttpResponseError].
  const HttpResponseError({
    this.request,
    this.response,
  });

  /// The associated request.
  final WebResourceRequest? request;

  /// The associated response.
  final WebResourceResponse? response;
}
