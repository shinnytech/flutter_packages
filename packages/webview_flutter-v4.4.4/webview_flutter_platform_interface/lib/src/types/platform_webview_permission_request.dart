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

import 'package:flutter/cupertino.dart';

/// Types of resources that can require permissions.
///
/// Platform specific implementations can create their own resource types.
///
/// This example demonstrates how to extend the [WebViewPermissionResourceType]
/// to create additional platform-specific types:
///
/// ```dart
/// class AndroidWebViewPermissionResourceType
///     extends WebViewPermissionResourceType {
///   const AndroidWebViewPermissionResourceType._(super.name);
///
///   static const AndroidWebViewPermissionResourceType midiSysex =
///       AndroidWebViewPermissionResourceType._('midiSysex');
///
///   static const AndroidWebViewPermissionResourceType protectedMediaId =
///       AndroidWebViewPermissionResourceType._('protectedMediaId');
/// }
///```
///
@immutable
class WebViewPermissionResourceType {
  /// Constructs a [WebViewPermissionResourceType].
  ///
  /// This should only be used by this class and subclasses in platform
  /// implementations.
  @protected
  const WebViewPermissionResourceType(this.name);

  /// Unique name of the resource type.
  ///
  /// For platform implementations, this should match the name of variable.
  final String name;

  /// A media device that can capture video.
  static const WebViewPermissionResourceType camera =
      WebViewPermissionResourceType('camera');

  /// A media device that can capture audio.
  static const WebViewPermissionResourceType microphone =
      WebViewPermissionResourceType('microphone');
}

/// Permissions request when web content requests access to protected resources.
///
/// A response MUST be provided by calling a provided method.
///
/// Platform specific implementations can add additional methods when extending
/// this class.
///
/// This example demonstrates how to extend the
/// [PlatformWebViewPermissionRequest] to provide additional platform-specific
/// features:
///
/// ```dart
/// class WebKitWebViewPermissionRequest extends PlatformWebViewPermissionRequest {
///   const WebKitWebViewPermissionRequest._({
///     required super.types,
///     required void Function(WKPermissionDecision decision) onDecision,
///   }) : _onDecision = onDecision;
///
///   final void Function(WKPermissionDecision) _onDecision;
///
///   @override
///   Future<void> grant() async {
///     _onDecision(WKPermissionDecision.grant);
///   }
///
///   @override
///   Future<void> deny() async {
///     _onDecision(WKPermissionDecision.deny);
///   }
///
///   Future<void> prompt() async {
///     _onDecision(WKPermissionDecision.prompt);
///   }
/// }
/// ```
@immutable
abstract class PlatformWebViewPermissionRequest {
  /// Creates a [PlatformWebViewPermissionRequest].
  const PlatformWebViewPermissionRequest({required this.types});

  /// All resources access has been requested for.
  final Set<WebViewPermissionResourceType> types;

  /// Grant permission for the requested resource(s).
  Future<void> grant();

  /// Deny permission for the requested resource(s).
  Future<void> deny();
}
