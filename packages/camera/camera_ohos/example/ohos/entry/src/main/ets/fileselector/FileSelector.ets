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

import fs from '@ohos.file.fs';
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { Result, FileSelectorApiCodec} from './GeneratedFileSelectorApi'
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';
import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';
import { AbilityPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityPluginBinding';
import ArrayList from '@ohos.util.ArrayList';

const TAG = "FileSelector";
export class FileSelector {

  binding: AbilityPluginBinding;

  constructor(binding: AbilityPluginBinding) {
    this.binding = binding;
  }

  async openFileByPath(path: string, result: Result<number>): Promise<void> {
    try {
      let file = await fs.open(path);
      result.success(file.fd);
    } catch (err) {
      Log.e(TAG, 'open file failed with err: ' + err);
      result.error(new Error("Failed to read file"));
    }
  }

  static getCodec(): MessageCodec<ESObject> {
    return FileSelectorApiCodec.INSTANCE;
  }

  setup(binaryMessenger: BinaryMessenger, abilityPluginBinding: AbilityPluginBinding): void {
    let api = this;
    {
      this.binding = abilityPluginBinding;
      const channel: BasicMessageChannel<ESObject> = new BasicMessageChannel<ESObject>(
        binaryMessenger, "dev.flutter.FileSelectorApi.openFileByPath", FileSelector.getCodec());
      channel.setMessageHandler({
        onMessage(msg: ESObject, reply: Reply<ESObject>): void {
          Log.d(TAG, 'onMessage reply:' + reply)
          const wrapped: Array<ESObject> = new Array<ESObject>();
          const args: Array<ESObject> = msg as Array<ESObject>;
          const path = args[0] as string;
          const resultCallback: Result<number> = new ResultBuilder((result: number): void => {
            wrapped.push(result);
            reply.reply(wrapped);
          },(error: Error): void => {
            const wrappedError: ArrayList<ESObject> = msg.wrapError(error);
            reply.reply(wrappedError);
          })
          api.openFileByPath(path, resultCallback);
        }
      });
    }
  }
}

class ResultBuilder{
  success : (result: number)=>void
  error: (error: Error) =>void

  constructor(success:ESObject , error:ESObject) {
    this.success = success
    this.error = error
  }
}