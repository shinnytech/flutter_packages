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

import '../types/http_auth_request.dart';

/// Defines the response parameters of a pending [HttpAuthRequest] received by
/// the webview.
@immutable
class WebViewCredential {
  /// Creates a [WebViewCredential].
  const WebViewCredential({
    required this.user,
    required this.password,
  });

  /// The user name.
  final String user;

  /// The password.
  final String password;
}
