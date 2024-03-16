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

import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { CustomViewCallback } from './CustomViewCallbackFlutterApiImpl';
import { CustomViewCallbackHostApi } from './GeneratedOhosWebView';
import { InstanceManager } from './InstanceManager';

export class CustomViewCallbackHostApiImpl extends CustomViewCallbackHostApi {

  private binaryMessenger:BinaryMessenger ;

  private instanceManager:InstanceManager;

  constructor(binaryMessenger:BinaryMessenger, instanceManager:InstanceManager) {
    super()
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
  }


  onCustomViewHidden(identifier: number): void {
    this.getCustomViewCallbackInstance(identifier).onCustomViewHidden()
  }

  private getCustomViewCallbackInstance(identifier: number): CustomViewCallback{
    return this.instanceManager.getInstance(identifier)
  }
}
