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

/// Defines the parameters that support `PlatformWebViewController.setOnJavaScriptAlertDialog`.
@immutable
class JavaScriptAlertDialogRequest {
  /// Creates a [JavaScriptAlertDialogRequest].
  const JavaScriptAlertDialogRequest({
    required this.message,
    required this.url,
  });

  /// The message to be displayed in the window.
  final String message;

  /// The URL of the page requesting the dialog.
  final String url;
}

/// Defines the parameters that support `PlatformWebViewController.setOnJavaScriptConfirmDialog`.
@immutable
class JavaScriptConfirmDialogRequest {
  /// Creates a [JavaScriptConfirmDialogRequest].
  const JavaScriptConfirmDialogRequest({
    required this.message,
    required this.url,
  });

  /// The message to be displayed in the window.
  final String message;

  /// The URL of the page requesting the dialog.
  final String url;
}

/// Defines the parameters that support `PlatformWebViewController.setOnJavaScriptTextInputDialog`.
@immutable
class JavaScriptTextInputDialogRequest {
  /// Creates a [JavaScriptAlertDialogRequest].
  const JavaScriptTextInputDialogRequest({
    required this.message,
    required this.url,
    required this.defaultText,
  });

  /// The message to be displayed in the window.
  final String message;

  /// The URL of the page requesting the dialog.
  final String url;

  /// The initial text to display in the text entry field.
  final String? defaultText;
}
