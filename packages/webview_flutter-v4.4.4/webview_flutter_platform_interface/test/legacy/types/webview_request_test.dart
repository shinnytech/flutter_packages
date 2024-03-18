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

import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter_platform_interface/src/webview_flutter_platform_interface_legacy.dart';

void main() {
  test('WebViewRequestMethod should serialize correctly', () {
    expect(WebViewRequestMethod.get.serialize(), 'get');
    expect(WebViewRequestMethod.post.serialize(), 'post');
  });

  test('WebViewRequest should serialize correctly', () {
    WebViewRequest request;
    Map<String, dynamic> serializedRequest;
    // Test serialization without headers or a body
    request = WebViewRequest(
      uri: Uri.parse('https://flutter.dev'),
      method: WebViewRequestMethod.get,
    );
    serializedRequest = request.toJson();
    expect(serializedRequest['uri'], 'https://flutter.dev');
    expect(serializedRequest['method'], 'get');
    expect(serializedRequest['headers'], <String, String>{});
    expect(serializedRequest['body'], null);
    // Test serialization of headers and body
    request = WebViewRequest(
      uri: Uri.parse('https://flutter.dev'),
      method: WebViewRequestMethod.get,
      headers: <String, String>{'foo': 'bar'},
      body: Uint8List.fromList('Example Body'.codeUnits),
    );
    serializedRequest = request.toJson();
    expect(serializedRequest['headers'], <String, String>{'foo': 'bar'});
    expect(serializedRequest['body'], 'Example Body'.codeUnits);
  });
}
