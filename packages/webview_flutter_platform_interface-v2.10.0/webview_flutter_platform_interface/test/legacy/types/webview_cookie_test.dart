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

import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter_platform_interface/src/webview_flutter_platform_interface_legacy.dart';

void main() {
  test('WebViewCookie should serialize correctly', () {
    WebViewCookie cookie;
    Map<String, String> serializedCookie;
    // Test serialization
    cookie = const WebViewCookie(
        name: 'foo', value: 'bar', domain: 'example.com', path: '/test');
    serializedCookie = cookie.toJson();
    expect(serializedCookie['name'], 'foo');
    expect(serializedCookie['value'], 'bar');
    expect(serializedCookie['domain'], 'example.com');
    expect(serializedCookie['path'], '/test');
  });
}
