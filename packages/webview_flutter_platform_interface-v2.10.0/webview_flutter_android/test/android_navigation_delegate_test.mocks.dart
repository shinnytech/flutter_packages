// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Mocks generated by Mockito 5.4.4 from annotations
// in webview_flutter_android/test/android_navigation_delegate_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:webview_flutter_android/src/android_webview.dart' as _i2;

import 'test_android_webview.g.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeJavaObject_0 extends _i1.SmartFake implements _i2.JavaObject {
  _FakeJavaObject_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TestInstanceManagerHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestInstanceManagerHostApi extends _i1.Mock
    implements _i3.TestInstanceManagerHostApi {
  MockTestInstanceManagerHostApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void clear() => super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [HttpAuthHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpAuthHandler extends _i1.Mock implements _i2.HttpAuthHandler {
  MockHttpAuthHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> cancel() => (super.noSuchMethod(
        Invocation.method(
          #cancel,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> proceed(
    String? username,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #proceed,
          [
            username,
            password,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<bool> useHttpAuthUsernamePassword() => (super.noSuchMethod(
        Invocation.method(
          #useHttpAuthUsernamePassword,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i2.JavaObject copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeJavaObject_0(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.JavaObject);
}
