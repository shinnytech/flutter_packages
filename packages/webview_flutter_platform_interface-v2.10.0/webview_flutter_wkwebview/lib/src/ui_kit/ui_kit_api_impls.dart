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

import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';

import '../common/instance_manager.dart';
import '../common/web_kit.g.dart';
import '../foundation/foundation.dart';
import '../web_kit/web_kit.dart';
import 'ui_kit.dart';

/// Host api implementation for [UIScrollView].
class UIScrollViewHostApiImpl extends UIScrollViewHostApi {
  /// Constructs a [UIScrollViewHostApiImpl].
  UIScrollViewHostApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  })  : instanceManager = instanceManager ?? NSObject.globalInstanceManager,
        super(binaryMessenger: binaryMessenger);

  /// Sends binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to
  /// the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with Objective-C objects.
  final InstanceManager instanceManager;

  /// Calls [createFromWebView] with the ids of the provided object instances.
  Future<void> createFromWebViewForInstances(
    UIScrollView instance,
    WKWebView webView,
  ) {
    return createFromWebView(
      instanceManager.addDartCreatedInstance(instance),
      instanceManager.getIdentifier(webView)!,
    );
  }

  /// Calls [getContentOffset] with the ids of the provided object instances.
  Future<Point<double>> getContentOffsetForInstances(
    UIScrollView instance,
  ) async {
    final List<double?> point = await getContentOffset(
      instanceManager.getIdentifier(instance)!,
    );
    return Point<double>(point[0]!, point[1]!);
  }

  /// Calls [scrollBy] with the ids of the provided object instances.
  Future<void> scrollByForInstances(
    UIScrollView instance,
    Point<double> offset,
  ) {
    return scrollBy(
      instanceManager.getIdentifier(instance)!,
      offset.x,
      offset.y,
    );
  }

  /// Calls [setContentOffset] with the ids of the provided object instances.
  Future<void> setContentOffsetForInstances(
    UIScrollView instance,
    Point<double> offset,
  ) async {
    return setContentOffset(
      instanceManager.getIdentifier(instance)!,
      offset.x,
      offset.y,
    );
  }
}

/// Host api implementation for [UIView].
class UIViewHostApiImpl extends UIViewHostApi {
  /// Constructs a [UIViewHostApiImpl].
  UIViewHostApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  })  : instanceManager = instanceManager ?? NSObject.globalInstanceManager,
        super(binaryMessenger: binaryMessenger);

  /// Sends binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to
  /// the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with Objective-C objects.
  final InstanceManager instanceManager;

  /// Calls [setBackgroundColor] with the ids of the provided object instances.
  Future<void> setBackgroundColorForInstances(
    UIView instance,
    Color? color,
  ) async {
    return setBackgroundColor(
      instanceManager.getIdentifier(instance)!,
      color?.value,
    );
  }

  /// Calls [setOpaque] with the ids of the provided object instances.
  Future<void> setOpaqueForInstances(
    UIView instance,
    bool opaque,
  ) async {
    return setOpaque(instanceManager.getIdentifier(instance)!, opaque);
  }
}
