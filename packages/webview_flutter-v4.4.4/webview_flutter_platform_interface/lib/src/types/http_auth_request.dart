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
import 'webview_credential.dart';

/// Defines the parameters of a pending HTTP authentication request received by
/// the webview through a [HttpAuthRequestCallback].
///
/// Platform specific implementations can add additional fields by extending
/// this class and providing a factory method that takes the [HttpAuthRequest]
/// as a parameter.
///
/// This example demonstrates how to extend the [HttpAuthRequest] to provide
/// additional platform specific parameters.
///
/// When extending [HttpAuthRequest], additional parameters should always accept
/// `null` or have a default value to prevent breaking changes.
///
/// ```dart
/// @immutable
/// class WKWebViewHttpAuthRequest extends HttpAuthRequest {
///   WKWebViewHttpAuthRequest._(
///     HttpAuthRequest authRequest,
///     this.extraData,
///   ) : super(
///      onProceed: authRequest.onProceed,
///      onCancel: authRequest.onCancel,
///      host: authRequest.host,
///      realm: authRequest.realm,
///   );
///
///   factory WKWebViewHttpAuthRequest.fromHttpAuthRequest(
///     HttpAuthRequest authRequest, {
///     String? extraData,
///   }) {
///     return WKWebViewHttpAuthRequest._(
///       authRequest,
///       extraData: extraData,
///     );
///   }
///
///   final String? extraData;
/// }
/// ```
@immutable
class HttpAuthRequest {
  /// Creates a [HttpAuthRequest].
  const HttpAuthRequest({
    required this.onProceed,
    required this.onCancel,
    required this.host,
    this.realm,
  });

  /// The callback to authenticate.
  final void Function(WebViewCredential credential) onProceed;

  /// The callback to cancel authentication.
  final void Function() onCancel;

  /// The host requiring authentication.
  final String host;

  /// The realm requiring authentication.
  final String? realm;
}
