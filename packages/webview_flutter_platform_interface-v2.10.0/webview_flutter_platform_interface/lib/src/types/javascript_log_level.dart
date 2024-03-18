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

/// Represents the severity of a JavaScript log message.
enum JavaScriptLogLevel {
  /// Indicates an error message was logged via an "error" event of the
  /// `console.error` method.
  error,

  /// Indicates a warning message was logged using the `console.warning`
  /// method.
  warning,

  /// Indicates a debug message was logged using the `console.debug` method.
  debug,

  /// Indicates an informational message was logged using the `console.info`
  /// method.
  info,

  /// Indicates a log message was logged using the `console.log` method.
  log,
}
