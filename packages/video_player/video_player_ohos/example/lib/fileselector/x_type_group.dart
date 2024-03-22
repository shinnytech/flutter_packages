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

import 'package:flutter/foundation.dart' show immutable;

/// A set of allowed XTypes.
@immutable
class XTypeGroup {
  /// Creates a new group with the given label and file extensions.
  ///
  /// A group with none of the type options provided indicates that any type is
  /// allowed.
  const XTypeGroup({
    this.label,
    List<String>? extensions,
    this.mimeTypes,
    List<String>? uniformTypeIdentifiers,
    this.webWildCards,
    @Deprecated('Use uniformTypeIdentifiers instead') List<String>? macUTIs,
  })  : _extensions = extensions,
        assert(uniformTypeIdentifiers == null || macUTIs == null,
            'Only one of uniformTypeIdentifiers or macUTIs can be non-null'),
        uniformTypeIdentifiers = uniformTypeIdentifiers ?? macUTIs;

  /// The 'name' or reference to this group of types.
  final String? label;

  /// The MIME types for this group.
  final List<String>? mimeTypes;

  /// The uniform type identifiers for this group
  final List<String>? uniformTypeIdentifiers;

  /// The web wild cards for this group (ex: image/*, video/*).
  final List<String>? webWildCards;

  final List<String>? _extensions;

  /// The extensions for this group.
  List<String>? get extensions {
    return _removeLeadingDots(_extensions);
  }

  /// Converts this object into a JSON formatted object.
  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'label': label,
      'extensions': extensions,
      'mimeTypes': mimeTypes,
      'uniformTypeIdentifiers': uniformTypeIdentifiers,
      'webWildCards': webWildCards,
      // This is kept for backwards compatibility with anything that was
      // relying on it, including implementers of `MethodChannelFileSelector`
      // (since toJSON is used in the method channel parameter serialization).
      'macUTIs': uniformTypeIdentifiers,
    };
  }

  /// True if this type group should allow any file.
  bool get allowsAny {
    return (extensions?.isEmpty ?? true) &&
        (mimeTypes?.isEmpty ?? true) &&
        (uniformTypeIdentifiers?.isEmpty ?? true) &&
        (webWildCards?.isEmpty ?? true);
  }

  /// Returns the list of uniform type identifiers for this group
  @Deprecated('Use uniformTypeIdentifiers instead')
  List<String>? get macUTIs => uniformTypeIdentifiers;

  static List<String>? _removeLeadingDots(List<String>? exts) => exts
      ?.map((String ext) => ext.startsWith('.') ? ext.substring(1) : ext)
      .toList();
}
