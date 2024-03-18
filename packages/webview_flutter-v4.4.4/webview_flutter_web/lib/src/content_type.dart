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

/// Class to represent a content-type header value.
class ContentType {
  /// Creates a [ContentType] instance by parsing a "content-type" response [header].
  ///
  /// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type
  /// See: https://httpwg.org/specs/rfc9110.html#media.type
  ContentType.parse(String header) {
    final Iterable<String> chunks =
        header.split(';').map((String e) => e.trim().toLowerCase());

    for (final String chunk in chunks) {
      if (!chunk.contains('=')) {
        _mimeType = chunk;
      } else {
        final List<String> bits =
            chunk.split('=').map((String e) => e.trim()).toList();
        assert(bits.length == 2);
        switch (bits[0]) {
          case 'charset':
            _charset = bits[1];
          case 'boundary':
            _boundary = bits[1];
          default:
            throw StateError('Unable to parse "$chunk" in content-type.');
        }
      }
    }
  }

  String? _mimeType;
  String? _charset;
  String? _boundary;

  /// The MIME-type of the resource or the data.
  String? get mimeType => _mimeType;

  /// The character encoding standard.
  String? get charset => _charset;

  /// The separation boundary for multipart entities.
  String? get boundary => _boundary;
}
