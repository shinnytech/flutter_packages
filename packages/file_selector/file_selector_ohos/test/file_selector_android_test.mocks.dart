// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Mocks generated by Mockito 5.4.0 from annotations
// in file_selector_ohos/test/file_selector_ohos_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:file_selector_ohos/src/file_selector_api.g.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [FileSelectorApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockFileSelectorApi extends _i1.Mock implements _i2.FileSelectorApi {
  MockFileSelectorApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i2.FileResponse?> openFile(
    String? arg_initialDirectory,
    _i2.FileTypes? arg_allowedTypes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #openFile,
          [
            arg_initialDirectory,
            arg_allowedTypes,
          ],
        ),
        returnValue: _i3.Future<_i2.FileResponse?>.value(),
      ) as _i3.Future<_i2.FileResponse?>);
  @override
  _i3.Future<List<_i2.FileResponse?>> openFiles(
    String? arg_initialDirectory,
    _i2.FileTypes? arg_allowedTypes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #openFiles,
          [
            arg_initialDirectory,
            arg_allowedTypes,
          ],
        ),
        returnValue:
            _i3.Future<List<_i2.FileResponse?>>.value(<_i2.FileResponse?>[]),
      ) as _i3.Future<List<_i2.FileResponse?>>);
  @override
  _i3.Future<String?> getDirectoryPath(String? arg_initialDirectory) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDirectoryPath,
          [arg_initialDirectory],
        ),
        returnValue: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);
}
