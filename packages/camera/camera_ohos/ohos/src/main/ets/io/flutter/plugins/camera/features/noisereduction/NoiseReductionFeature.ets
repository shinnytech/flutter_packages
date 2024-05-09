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
import { NoiseReductionMode } from './NoiseReductionMode';

export class NoiseReductionFeature extends CameraFeature<NoiseReductionMode>{

  private currentSetting : NoiseReductionMode = NoiseReductionMode.fast;

  constructor(cameraProperties : CameraProperties ) {
    super(cameraProperties)
  }

  public getDebugName(): string {
    return "NoiseReductionFeature";
  }

  public getValue(): NoiseReductionMode {
    return this.currentSetting;
  }

  public setValue(value: NoiseReductionMode): void {
    this.currentSetting = value;
  }

  public checkIsSupported(): boolean {
    let modes = super.cameraProperties.getAvailableNoiseReductionModes();
    return modes != null && modes.length > 0;
  }
}