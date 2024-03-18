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

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'types/types.dart';

import 'webview_platform.dart' show WebViewPlatform;

/// Signature for callbacks that report a pending navigation request.
typedef NavigationRequestCallback = FutureOr<NavigationDecision> Function(
    NavigationRequest navigationRequest);

/// Signature for callbacks that report page events triggered by the native web view.
typedef PageEventCallback = void Function(String url);

/// Signature for callbacks that report loading progress of a page.
typedef ProgressCallback = void Function(int progress);

/// Signature for callbacks that report http errors during loading a page.
typedef HttpResponseErrorCallback = void Function(HttpResponseError error);

/// Signature for callbacks that report a resource loading error.
typedef WebResourceErrorCallback = void Function(WebResourceError error);

/// Signature for callbacks that notify the host application of a change to the
/// url of the web view.
typedef UrlChangeCallback = void Function(UrlChange change);

/// Signature for callbacks that notify the host application of an
/// authentication request.
typedef HttpAuthRequestCallback = void Function(HttpAuthRequest request);

/// An interface defining navigation events that occur on the native platform.
///
/// The [PlatformWebViewController] is notifying this delegate on events that
/// happened on the platform's webview. Platform implementations should
/// implement this class and pass an instance to the [PlatformWebViewController].
abstract class PlatformNavigationDelegate extends PlatformInterface {
  /// Creates a new [PlatformNavigationDelegate]
  factory PlatformNavigationDelegate(
      PlatformNavigationDelegateCreationParams params) {
    assert(
      WebViewPlatform.instance != null,
      'A platform implementation for `webview_flutter` has not been set. Please '
      'ensure that an implementation of `WebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformNavigationDelegate callbackDelegate =
        WebViewPlatform.instance!.createPlatformNavigationDelegate(params);
    PlatformInterface.verify(callbackDelegate, _token);
    return callbackDelegate;
  }

  /// Used by the platform implementation to create a new [PlatformNavigationDelegate].
  ///
  /// Should only be used by platform implementations because they can't extend
  /// a class that only contains a factory constructor.
  @protected
  PlatformNavigationDelegate.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  /// The parameters used to initialize the [PlatformNavigationDelegate].
  final PlatformNavigationDelegateCreationParams params;

  /// Invoked when a navigation request is pending.
  ///
  /// See [PlatformWebViewController.setPlatformNavigationDelegate].
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) {
    throw UnimplementedError(
        'setOnNavigationRequest is not implemented on the current platform.');
  }

  /// Invoked when a page has started loading.
  ///
  /// See [PlatformWebViewController.setPlatformNavigationDelegate].
  Future<void> setOnPageStarted(
    PageEventCallback onPageStarted,
  ) {
    throw UnimplementedError(
        'setOnPageStarted is not implemented on the current platform.');
  }

  /// Invoked when a page has finished loading.
  ///
  /// See [PlatformWebViewController.setPlatformNavigationDelegate].
  Future<void> setOnPageFinished(
    PageEventCallback onPageFinished,
  ) {
    throw UnimplementedError(
        'setOnPageFinished is not implemented on the current platform.');
  }

  /// Invoked when an HTTP error has occurred during loading.
  ///
  /// See [PlatformWebViewController.setPlatformNavigationDelegate].
  Future<void> setOnHttpError(
    HttpResponseErrorCallback onHttpError,
  ) {
    throw UnimplementedError(
        'setOnHttpError is not implemented on the current platform.');
  }

  /// Invoked when a page is loading to report the progress.
  ///
  /// See [PlatformWebViewController.setPlatformNavigationDelegate].
  Future<void> setOnProgress(
    ProgressCallback onProgress,
  ) {
    throw UnimplementedError(
        'setOnProgress is not implemented on the current platform.');
  }

  /// Invoked when a resource loading error occurred.
  ///
  /// See [PlatformWebViewController.setPlatformNavigationDelegate].
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) {
    throw UnimplementedError(
        'setOnWebResourceError is not implemented on the current platform.');
  }

  /// Invoked when the underlying web view changes to a new url.
  ///
  /// See [PlatformWebViewController.setPlatformNavigationDelegate].
  Future<void> setOnUrlChange(UrlChangeCallback onUrlChange) {
    throw UnimplementedError(
      'setOnUrlChange is not implemented on the current platform.',
    );
  }

  /// Invoked when the web view is requesting authentication.
  Future<void> setOnHttpAuthRequest(HttpAuthRequestCallback onHttpAuthRequest) {
    throw UnimplementedError(
      'setOnHttpAuthRequest is not implemented on the current platform.',
    );
  }
}
