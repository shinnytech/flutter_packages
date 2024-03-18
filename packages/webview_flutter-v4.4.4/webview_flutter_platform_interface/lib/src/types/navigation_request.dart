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

/// Defines the parameters of the pending navigation callback.
class NavigationRequest {
  /// Creates a [NavigationRequest].
  const NavigationRequest({
    required this.url,
    required this.isMainFrame,
  });

  /// The URL of the pending navigation request.
  final String url;

  /// Indicates whether the request was made in the web site's main frame or a subframe.
  final bool isMainFrame;
}
