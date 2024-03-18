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
  final List<String> validChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_'.split('');
  final List<String> commonInvalidChars =
      r'`~!@#$%^&*()-=+[]{}\|"' ':;/?<>,. '.split('');
  final List<int> digits = List<int>.generate(10, (int index) => index++);

  test(
      'ctor should create JavascriptChannel when name starts with a valid character followed by a number.',
      () {
    for (final String char in validChars) {
      for (final int digit in digits) {
        final JavascriptChannel channel =
            JavascriptChannel(name: '$char$digit', onMessageReceived: (_) {});

        expect(channel.name, '$char$digit');
      }
    }
  });

  test('ctor should assert when channel name starts with a number.', () {
    for (final int i in digits) {
      expect(
        () => JavascriptChannel(name: '$i', onMessageReceived: (_) {}),
        throwsAssertionError,
      );
    }
  });

  test('ctor should assert when channel contains invalid char.', () {
    for (final String validChar in validChars) {
      for (final String invalidChar in commonInvalidChars) {
        expect(
          () => JavascriptChannel(
              name: validChar + invalidChar, onMessageReceived: (_) {}),
          throwsAssertionError,
        );
      }
    }
  });
}
