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

/// Object specifying creation parameters for creating a [PlatformWebViewController].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
/// {@tool sample}
/// This example demonstrates how to extend the [PlatformWebViewControllerCreationParams] to
/// provide additional platform specific parameters.
///
/// When extending [PlatformWebViewControllerCreationParams] additional parameters
/// should always accept `null` or have a default value to prevent breaking
/// changes.
///
/// ```dart
/// class WKWebViewControllerCreationParams
///     extends PlatformWebViewControllerCreationParams {
///   WKWebViewControllerCreationParams._(
///     // This parameter prevents breaking changes later.
///     // ignore: avoid_unused_constructor_parameters
///     PlatformWebViewControllerCreationParams params, {
///     this.domain,
///   }) : super();
///
///   factory WKWebViewControllerCreationParams.fromPlatformWebViewControllerCreationParams(
///     PlatformWebViewControllerCreationParams params, {
///     String? domain,
///   }) {
///     return WKWebViewControllerCreationParams._(params, domain: domain);
///   }
///
///   final String? domain;
/// }
/// ```
/// {@end-tool}
@immutable
class PlatformWebViewControllerCreationParams {
  /// Used by the platform implementation to create a new [PlatformWebViewController].
  const PlatformWebViewControllerCreationParams();
}
