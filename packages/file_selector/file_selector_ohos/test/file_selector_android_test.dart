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

import 'dart:typed_data';

import 'package:file_selector_ohos/src/file_selector_ohos.dart';
import 'package:file_selector_ohos/src/file_selector_api.g.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'file_selector_ohos_test.mocks.dart';

@GenerateMocks(<Type>[FileSelectorApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FileSelectorAndroid plugin;
  late MockFileSelectorApi mockApi;

  setUp(() {
    mockApi = MockFileSelectorApi();
    plugin = FileSelectorAndroid(api: mockApi);
  });

  test('registered instance', () {
    FileSelectorAndroid.registerWith();
    expect(FileSelectorPlatform.instance, isA<FileSelectorAndroid>());
  });

  group('openFile', () {
    test('passes the accepted type groups correctly', () async {
      when(
        mockApi.openFile(
          'some/path/',
          argThat(
            isA<FileTypes>().having(
              (FileTypes types) => types.mimeTypes,
              'mimeTypes',
              <String>['text/plain', 'image/jpg'],
            ).having(
              (FileTypes types) => types.extensions,
              'extensions',
              <String>['txt', 'jpg'],
            ),
          ),
        ),
      ).thenAnswer(
        (_) => Future<FileResponse?>.value(
          FileResponse(
            path: 'some/path.txt',
            size: 30,
            bytes: Uint8List(0),
            name: 'name',
            mimeType: 'text/plain',
          ),
        ),
      );

      const XTypeGroup group = XTypeGroup(
        extensions: <String>['txt'],
        mimeTypes: <String>['text/plain'],
      );

      const XTypeGroup group2 = XTypeGroup(
        extensions: <String>['jpg'],
        mimeTypes: <String>['image/jpg'],
      );

      final XFile? file = await plugin.openFile(
        acceptedTypeGroups: <XTypeGroup>[group, group2],
        initialDirectory: 'some/path/',
      );

      expect(file?.path, 'some/path.txt');
      expect(file?.mimeType, 'text/plain');
      expect(await file?.length(), 30);
      expect(await file?.readAsBytes(), Uint8List(0));
    });
  });

  group('openFiles', () {
    test('passes the accepted type groups correctly', () async {
      when(
        mockApi.openFiles(
          'some/path/',
          argThat(
            isA<FileTypes>().having(
              (FileTypes types) => types.mimeTypes,
              'mimeTypes',
              <String>['text/plain', 'image/jpg'],
            ).having(
              (FileTypes types) => types.extensions,
              'extensions',
              <String>['txt', 'jpg'],
            ),
          ),
        ),
      ).thenAnswer(
        (_) => Future<List<FileResponse>>.value(
          <FileResponse>[
            FileResponse(
              path: 'some/path.txt',
              size: 30,
              bytes: Uint8List(0),
              name: 'name',
              mimeType: 'text/plain',
            ),
            FileResponse(
              path: 'other/dir.jpg',
              size: 40,
              bytes: Uint8List(0),
              mimeType: 'image/jpg',
            ),
          ],
        ),
      );

      const XTypeGroup group = XTypeGroup(
        extensions: <String>['txt'],
        mimeTypes: <String>['text/plain'],
      );

      const XTypeGroup group2 = XTypeGroup(
        extensions: <String>['jpg'],
        mimeTypes: <String>['image/jpg'],
      );

      final List<XFile> files = await plugin.openFiles(
        acceptedTypeGroups: <XTypeGroup>[group, group2],
        initialDirectory: 'some/path/',
      );

      expect(files[0].path, 'some/path.txt');
      expect(files[0].mimeType, 'text/plain');
      expect(await files[0].length(), 30);
      expect(await files[0].readAsBytes(), Uint8List(0));

      expect(files[1].path, 'other/dir.jpg');
      expect(files[1].mimeType, 'image/jpg');
      expect(await files[1].length(), 40);
      expect(await files[1].readAsBytes(), Uint8List(0));
    });
  });

  test('getDirectoryPath', () async {
    when(mockApi.getDirectoryPath('some/path'))
        .thenAnswer((_) => Future<String?>.value('some/path/chosen/'));

    final String? path = await plugin.getDirectoryPath(
      initialDirectory: 'some/path',
    );

    expect(path, 'some/path/chosen/');
  });
}
