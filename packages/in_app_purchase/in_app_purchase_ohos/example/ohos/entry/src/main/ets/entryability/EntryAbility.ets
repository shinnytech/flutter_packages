// Copyright (c) 2024 SwanLink (Jiangsu) Technology Development Co., LTD.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.

import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }
}
