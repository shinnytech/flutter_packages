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

import { FlutterAbility } from '@ohos/flutter_ohos'
import {
  WebViewFlutterPlugin
} from '@ohos/webview_flutter/src/main/ets/io.flutter.plugins/webview_flutter/WebViewFlutterPlugin'
import PathProviderPlugin from '@ohos/path_provider/src/main/ets/io/flutter/plugins/pathprovider/PathProviderPlugin'

export default class EntryAbility extends FlutterAbility {
  onFlutterEngineReady(): void {
    super.onFlutterEngineReady()
    this.addPlugin(new WebViewFlutterPlugin())
    this.addPlugin(new PathProviderPlugin())
  }

}
