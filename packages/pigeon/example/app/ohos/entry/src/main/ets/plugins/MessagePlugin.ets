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

import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import { ExampleHostApi, MessageData, Result } from './Messages';

class HostApiImp extends ExampleHostApi {
  getHostLanguage(): string {
    return 'ArkTS';
  }

  add(a: number, b: number): number {
    return a + b;
  }

  sendMessage(message: MessageData, result: Result<boolean>) {
    console.log("收到消息：" + message.getName());
  }
}

export default class MessagePlugin implements FlutterPlugin {

  constructor() {
  }

  getUniqueClassName(): string {
    return 'MessagePlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding) {
    ExampleHostApi.setup(binding.getBinaryMessenger(), new HostApiImp());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding) {
    //ExampleHostApi.setup(binding.getBinaryMessenger(), null);
  }
}