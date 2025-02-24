// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

class FileResponse {
  FileResponse({
    required this.path,
    this.mimeType,
    this.name,
    required this.size,
    required this.bytes,
  });

  String path;

  String? mimeType;

  String? name;

  int size;

  Uint8List bytes;

  Object encode() {
    return <Object?>[
      path,
      mimeType,
      name,
      size,
      bytes,
    ];
  }

  static FileResponse decode(Object result) {
    result as List<Object?>;
    return FileResponse(
      path: result[0]! as String,
      mimeType: result[1] as String?,
      name: result[2] as String?,
      size: result[3]! as int,
      bytes: result[4]! as Uint8List,
    );
  }
}

class FileTypes {
  FileTypes({
    required this.mimeTypes,
    required this.extensions,
  });

  List<String?> mimeTypes;

  List<String?> extensions;

  Object encode() {
    return <Object?>[
      mimeTypes,
      extensions,
    ];
  }

  static FileTypes decode(Object result) {
    result as List<Object?>;
    return FileTypes(
      mimeTypes: (result[0] as List<Object?>?)!.cast<String?>(),
      extensions: (result[1] as List<Object?>?)!.cast<String?>(),
    );
  }
}

class _FileSelectorApiCodec extends StandardMessageCodec {
  const _FileSelectorApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is FileResponse) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is FileTypes) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return FileResponse.decode(readValue(buffer)!);
      case 129:
        return FileTypes.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

/// An API to call to native code to select files or directories.
class FileSelectorApi {
  /// Constructor for [FileSelectorApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  FileSelectorApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _FileSelectorApiCodec();

  /// Opens a file dialog for loading files and returns a file path.
  ///
  /// Returns `null` if user cancels the operation.
  Future<FileResponse?> openFile(
      String? arg_initialDirectory, FileTypes arg_allowedTypes) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FileSelectorApi.openFile', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_initialDirectory, arg_allowedTypes])
            as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as FileResponse?);
    }
  }

  /// Opens a file dialog for loading files and returns a list of file responses
  /// chosen by the user.
  Future<List<FileResponse?>> openFiles(
      String? arg_initialDirectory, FileTypes arg_allowedTypes) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FileSelectorApi.openFiles', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_initialDirectory, arg_allowedTypes])
            as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<FileResponse?>();
    }
  }

  /// Opens a file dialog for loading directories and returns a directory path.
  ///
  /// Returns `null` if user cancels the operation.
  Future<String?> getDirectoryPath(String? arg_initialDirectory) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FileSelectorApi.getDirectoryPath', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_initialDirectory]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as String?);
    }
  }
}
