/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
 
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, unnecessary_import
// ignore_for_file: avoid_relative_lib_imports
import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;
import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:image_picker_android/src/messages.g.dart';

class _TestHostImagePickerApiCodec extends StandardMessageCodec {
  const _TestHostImagePickerApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CacheRetrievalError) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CacheRetrievalResult) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is GeneralOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is ImageSelectionOptions) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is MediaSelectionOptions) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is SourceSpecification) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is VideoSelectionOptions) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CacheRetrievalError.decode(readValue(buffer)!);
      case 129:
        return CacheRetrievalResult.decode(readValue(buffer)!);
      case 130:
        return GeneralOptions.decode(readValue(buffer)!);
      case 131:
        return ImageSelectionOptions.decode(readValue(buffer)!);
      case 132:
        return MediaSelectionOptions.decode(readValue(buffer)!);
      case 133:
        return SourceSpecification.decode(readValue(buffer)!);
      case 134:
        return VideoSelectionOptions.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class TestHostImagePickerApi {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding =>
      TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> codec = _TestHostImagePickerApiCodec();

  /// Selects images and returns their paths.
  ///
  /// Elements must not be null, by convention. See
  /// https://github.com/flutter/flutter/issues/97848
  Future<List<String?>> pickImages(SourceSpecification source,
      ImageSelectionOptions options, GeneralOptions generalOptions);

  /// Selects video and returns their paths.
  ///
  /// Elements must not be null, by convention. See
  /// https://github.com/flutter/flutter/issues/97848
  Future<List<String?>> pickVideos(SourceSpecification source,
      VideoSelectionOptions options, GeneralOptions generalOptions);

  /// Selects images and videos and returns their paths.
  ///
  /// Elements must not be null, by convention. See
  /// https://github.com/flutter/flutter/issues/97848
  Future<List<String?>> pickMedia(MediaSelectionOptions mediaSelectionOptions,
      GeneralOptions generalOptions);

  /// Returns results from a previous app session, if any.
  CacheRetrievalResult? retrieveLostResults();

  static void setup(TestHostImagePickerApi? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ImagePickerApi.pickImages', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickImages was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final SourceSpecification? arg_source =
              (args[0] as SourceSpecification?);
          assert(arg_source != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickImages was null, expected non-null SourceSpecification.');
          final ImageSelectionOptions? arg_options =
              (args[1] as ImageSelectionOptions?);
          assert(arg_options != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickImages was null, expected non-null ImageSelectionOptions.');
          final GeneralOptions? arg_generalOptions =
              (args[2] as GeneralOptions?);
          assert(arg_generalOptions != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickImages was null, expected non-null GeneralOptions.');
          final List<String?> output = await api.pickImages(
              arg_source!, arg_options!, arg_generalOptions!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ImagePickerApi.pickVideos', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickVideos was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final SourceSpecification? arg_source =
              (args[0] as SourceSpecification?);
          assert(arg_source != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickVideos was null, expected non-null SourceSpecification.');
          final VideoSelectionOptions? arg_options =
              (args[1] as VideoSelectionOptions?);
          assert(arg_options != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickVideos was null, expected non-null VideoSelectionOptions.');
          final GeneralOptions? arg_generalOptions =
              (args[2] as GeneralOptions?);
          assert(arg_generalOptions != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickVideos was null, expected non-null GeneralOptions.');
          final List<String?> output = await api.pickVideos(
              arg_source!, arg_options!, arg_generalOptions!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ImagePickerApi.pickMedia', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickMedia was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MediaSelectionOptions? arg_mediaSelectionOptions =
              (args[0] as MediaSelectionOptions?);
          assert(arg_mediaSelectionOptions != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickMedia was null, expected non-null MediaSelectionOptions.');
          final GeneralOptions? arg_generalOptions =
              (args[1] as GeneralOptions?);
          assert(arg_generalOptions != null,
              'Argument for dev.flutter.pigeon.ImagePickerApi.pickMedia was null, expected non-null GeneralOptions.');
          final List<String?> output = await api.pickMedia(
              arg_mediaSelectionOptions!, arg_generalOptions!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ImagePickerApi.retrieveLostResults', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          // ignore message
          final CacheRetrievalResult? output = api.retrieveLostResults();
          return <Object?>[output];
        });
      }
    }
  }
}
