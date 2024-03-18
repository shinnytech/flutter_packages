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
import 'package:webview_flutter_web/src/content_type.dart';

void main() {
  group('ContentType.parse', () {
    test('basic content-type (lowers case)', () {
      final ContentType contentType = ContentType.parse('text/pLaIn');

      expect(contentType.mimeType, 'text/plain');
      expect(contentType.boundary, isNull);
      expect(contentType.charset, isNull);
    });

    test('with charset', () {
      final ContentType contentType =
          ContentType.parse('text/pLaIn; charset=utf-8');

      expect(contentType.mimeType, 'text/plain');
      expect(contentType.boundary, isNull);
      expect(contentType.charset, 'utf-8');
    });

    test('with boundary', () {
      final ContentType contentType =
          ContentType.parse('text/pLaIn; boundary=---xyz');

      expect(contentType.mimeType, 'text/plain');
      expect(contentType.boundary, '---xyz');
      expect(contentType.charset, isNull);
    });

    test('with charset and boundary', () {
      final ContentType contentType =
          ContentType.parse('text/pLaIn; charset=utf-8; boundary=---xyz');

      expect(contentType.mimeType, 'text/plain');
      expect(contentType.boundary, '---xyz');
      expect(contentType.charset, 'utf-8');
    });

    test('with boundary and charset', () {
      final ContentType contentType =
          ContentType.parse('text/pLaIn; boundary=---xyz; charset=utf-8');

      expect(contentType.mimeType, 'text/plain');
      expect(contentType.boundary, '---xyz');
      expect(contentType.charset, 'utf-8');
    });

    test('with a bunch of whitespace, boundary and charset', () {
      final ContentType contentType = ContentType.parse(
          '     text/pLaIn   ; boundary=---xyz;    charset=utf-8    ');

      expect(contentType.mimeType, 'text/plain');
      expect(contentType.boundary, '---xyz');
      expect(contentType.charset, 'utf-8');
    });

    test('empty string', () {
      final ContentType contentType = ContentType.parse('');

      expect(contentType.mimeType, '');
      expect(contentType.boundary, isNull);
      expect(contentType.charset, isNull);
    });

    test('unknown parameter (throws)', () {
      expect(() {
        ContentType.parse('text/pLaIn; wrong=utf-8');
      }, throwsStateError);
    });
  });
}
