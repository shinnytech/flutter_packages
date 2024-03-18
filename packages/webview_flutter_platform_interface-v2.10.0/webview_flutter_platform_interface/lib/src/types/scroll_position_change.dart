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

/// Defines the parameters of the scroll position change callback.
class ScrollPositionChange {
  /// Creates a [ScrollPositionChange].
  const ScrollPositionChange(this.x, this.y);

  /// The value of the horizontal offset with the origin being at the leftmost
  /// of the `WebView`.
  final double x;

  /// The value of the vertical offset with the origin being at the topmost of
  /// the `WebView`.
  final double y;
}
