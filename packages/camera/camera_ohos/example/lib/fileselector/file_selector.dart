// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'file_selector_api.dart';

class FileSelector {
  FileSelector({ FileSelectorApi? api})
      : _api = api ?? FileSelectorApi();

  final FileSelectorApi _api;

  /// Registers this class as the implementation of the file_selector platform interface.
  ///
  @override
  Future<int?> openFileByPath(String path) async {
    final int? fd = await _api.openFileByPath(path);
    print("openfile#");
    print(fd);
    return fd;
  }
}