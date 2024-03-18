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

import 'package:flutter/material.dart';

/// Object specifying creation parameters for creating a [PlatformWebViewCookieManager].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
/// {@tool sample}
/// This example demonstrates how to extend the [PlatformWebViewCookieManagerCreationParams] to
/// provide additional platform specific parameters.
///
/// When extending [PlatformWebViewCookieManagerCreationParams] additional
/// parameters should always accept `null` or have a default value to prevent
/// breaking changes.
///
/// ```dart
/// class WKWebViewCookieManagerCreationParams
///     extends PlatformWebViewCookieManagerCreationParams {
///   WKWebViewCookieManagerCreationParams._(
///     // This parameter prevents breaking changes later.
///     // ignore: avoid_unused_constructor_parameters
///     PlatformWebViewCookieManagerCreationParams params, {
///     this.uri,
///   }) : super();
///
///   factory WKWebViewCookieManagerCreationParams.fromPlatformWebViewCookieManagerCreationParams(
///     PlatformWebViewCookieManagerCreationParams params, {
///     Uri? uri,
///   }) {
///     return WKWebViewCookieManagerCreationParams._(params, uri: uri);
///   }
///
///   final Uri? uri;
/// }
/// ```
/// {@end-tool}
@immutable
class PlatformWebViewCookieManagerCreationParams {
  /// Used by the platform implementation to create a new [PlatformWebViewCookieManagerDelegate].
  const PlatformWebViewCookieManagerCreationParams();
}
