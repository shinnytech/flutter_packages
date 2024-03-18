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

import 'package:meta/meta.dart';

import 'javascript_log_level.dart';

/// Represents a console message written to the JavaScript console.
@immutable
class JavaScriptConsoleMessage {
  /// Creates a [JavaScriptConsoleMessage].
  const JavaScriptConsoleMessage({
    required this.level,
    required this.message,
  });

  /// The severity of a JavaScript log message.
  final JavaScriptLogLevel level;

  /// The message written to the console.
  final String message;
}
