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

import '../platform_webview_controller.dart';

/// Defines the supported HTTP methods for loading a page in [PlatformWebViewController].
enum LoadRequestMethod {
  /// HTTP GET method.
  get,

  /// HTTP POST method.
  post,
}

/// Extension methods on the [LoadRequestMethod] enum.
extension LoadRequestMethodExtensions on LoadRequestMethod {
  /// Converts [LoadRequestMethod] to [String] format.
  String serialize() {
    switch (this) {
      case LoadRequestMethod.get:
        return 'get';
      case LoadRequestMethod.post:
        return 'post';
    }
  }
}

/// Defines the parameters that can be used to load a page with the [PlatformWebViewController].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
/// {@tool sample}
/// This example demonstrates how to extend the [LoadRequestParams] to
/// provide additional platform specific parameters.
///
/// When extending [LoadRequestParams] additional parameters should always
/// accept `null` or have a default value to prevent breaking changes.
///
/// ```dart
/// class AndroidLoadRequestParams extends LoadRequestParams {
///   AndroidLoadRequestParams._({
///     required LoadRequestParams params,
///     this.historyUrl,
///   }) : super(
///     uri: params.uri,
///     method: params.method,
///     body: params.body,
///     headers: params.headers,
///   );
///
///   factory AndroidLoadRequestParams.fromLoadRequestParams(
///     LoadRequestParams params, {
///     Uri? historyUrl,
///   }) {
///     return AndroidLoadRequestParams._(params, historyUrl: historyUrl);
///   }
///
///   final Uri? historyUrl;
/// }
/// ```
/// {@end-tool}
@immutable
class LoadRequestParams {
  /// Used by the platform implementation to create a new [LoadRequestParams].
  const LoadRequestParams({
    required this.uri,
    this.method = LoadRequestMethod.get,
    this.headers = const <String, String>{},
    this.body,
  });

  /// URI for the request.
  final Uri uri;

  /// HTTP method used to make the request.
  ///
  /// Defaults to [LoadRequestMethod.get].
  final LoadRequestMethod method;

  /// Headers for the request.
  final Map<String, String> headers;

  /// HTTP body for the request.
  final Uint8List? body;
}
