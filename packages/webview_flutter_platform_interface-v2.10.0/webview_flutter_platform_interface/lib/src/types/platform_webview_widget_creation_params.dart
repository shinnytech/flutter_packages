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
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import '../platform_webview_controller.dart';

/// Object specifying creation parameters for creating a [WebViewWidgetDelegate].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
/// {@tool sample}
/// This example demonstrates how to extend the [PlatformWebViewWidgetCreationParams] to
/// provide additional platform specific parameters.
///
/// When extending [PlatformWebViewWidgetCreationParams] additional parameters
/// should always accept `null` or have a default value to prevent breaking
/// changes.
///
/// ```dart
/// class AndroidWebViewWidgetCreationParams
///     extends PlatformWebViewWidgetCreationParams {
///   AndroidWebViewWidgetCreationParams({
///     super.key,
///     super.layoutDirection,
///     super.gestureRecognizers,
///     this.platformSpecificFieldExample,
///   });
///
///   WKWebViewWidgetCreationParams.fromPlatformWebViewWidgetCreationParams(
///     PlatformWebViewWidgetCreationParams params, {
///     Object? platformSpecificFieldExample,
///   }) : this(
///           key: params.key,
///           layoutDirection: params.layoutDirection,
///           gestureRecognizers: params.gestureRecognizers,
///           platformSpecificFieldExample: platformSpecificFieldExample,
///         );
///
///   final Object? platformSpecificFieldExample;
/// }
/// ```
/// {@end-tool}
@immutable
class PlatformWebViewWidgetCreationParams {
  /// Used by the platform implementation to create a new [PlatformWebViewWidget].
  const PlatformWebViewWidgetCreationParams({
    this.key,
    required this.controller,
    this.layoutDirection = TextDirection.ltr,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });

  /// Controls how one widget replaces another widget in the tree.
  ///
  /// See also:
  ///
  ///  * The discussions at [Key] and [GlobalKey].
  final Key? key;

  /// The [PlatformWebViewController] that allows controlling the native web
  /// view.
  final PlatformWebViewController controller;

  /// The layout direction to use for the embedded WebView.
  final TextDirection layoutDirection;

  /// The `gestureRecognizers` specifies which gestures should be consumed by the
  /// web view.
  ///
  /// It is possible for other gesture recognizers to be competing with the web
  /// view on pointer events, e.g. if the web view is inside a [ListView] the
  /// [ListView] will want to handle vertical drags. The web view will claim
  /// gestures that are recognized by any of the recognizers on this list.
  ///
  /// When `gestureRecognizers` is empty (default), the web view will only handle
  /// pointer events for gestures that were not claimed by any other gesture
  /// recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
}
