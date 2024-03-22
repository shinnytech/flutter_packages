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

import 'package:example/fileselector/x_type_group.dart';
import 'file_selector_api.dart';

class FileSelector {
  FileSelector({ FileSelectorApi? api})
      : _api = api ?? FileSelectorApi();

  final FileSelectorApi _api;

  /// Registers this class as the implementation of the file_selector platform interface.
  // static void registerWith() {
  //   FileSelectorPlatform.instance = FileSelectorAndroid();
  // }

  @override
  Future<int?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? confirmButtonText,
  }) async {
    final FileResponse? file = await _api.openFile(
      _fileTypesFromTypeGroups(acceptedTypeGroups),
    );
    print("openfile#");
    print(file?.fd);
    return file?.fd;
  }



  FileTypes _fileTypesFromTypeGroups(List<XTypeGroup>? typeGroups) {
    if (typeGroups == null) {
      return FileTypes(extensions: <String>[], mimeTypes: <String>[]);
    }

    final Set<String> mimeTypes = <String>{};
    final Set<String> extensions = <String>{};

    for (final XTypeGroup group in typeGroups) {
      if (!group.allowsAny &&
          group.mimeTypes == null &&
          group.extensions == null) {
        throw ArgumentError(
          'Provided type group $group does not allow all files, but does not '
              'set any of the Android supported filter categories. At least one of '
              '"extensions" or "mimeTypes" must be non-empty for Android.',
        );
      }

      mimeTypes.addAll(group.mimeTypes ?? <String>{});
      extensions.addAll(group.extensions ?? <String>{});
    }

    return FileTypes(
      mimeTypes: mimeTypes.toList(),
      extensions: extensions.toList(),
    );
  }
}