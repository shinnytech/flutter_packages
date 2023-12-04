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
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import { FlutterAbility } from '@ohos/flutter_embedding/src/main/ets/embedding/ohos/FlutterAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import LocalAuthPlugin from '@ohos/local_auth_ohos/src/main/ets/io/flutter/plugins/localauth/LocalAuthPlugin';

export default class EntryAbility extends FlutterAbility {

  onFlutterEngineReady(): void {
    super.onFlutterEngineReady()
    this.addPlugin(new LocalAuthPlugin())
  }
}
