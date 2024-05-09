/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { CameraProperties } from '../../CameraProperties';
import { CameraFeature } from '../CameraFeature';
import { FlashMode } from './FlashMode';
import camera from '@ohos.multimedia.camera';

export class FlashFeature extends CameraFeature<FlashMode> {
  private currentSetting: FlashMode = camera.FlashMode.FLASH_MODE_AUTO;

  constructor(cameraProperties: CameraProperties) {
    super(cameraProperties)
  }

  public getDebugName(): string {
    return "FlashFeature";
  }

  public getValue(): FlashMode {
    return this.currentSetting;
  }

  public setValue(value: FlashMode): void {
    this.currentSetting = value;
  }

  public checkIsSupported(): boolean {
    let available = super.cameraProperties.getFlashInfoAvailable()
    return available != null && available;
  }
}