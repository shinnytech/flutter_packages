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
import camera from '@ohos.multimedia.camera';
import { CameraUtils } from '../../CameraUtils';

export class ExposureOffsetFeature extends CameraFeature<Number> {
  private currentSetting: number = 0;

  constructor(cameraProperties: CameraProperties) {
    super(cameraProperties)
  }

  public getDebugName(): string {
    return "ExposureOffsetFeature";
  }

  public getValue(): Number {
    return this.currentSetting;
  }

  public checkIsSupported(): boolean {
    return true;
  }

  public setValue(value: number, captureSession: camera.PhotoSession | camera.VideoSession): void {
    let stepSize = this.getExposureOffsetStepSize(captureSession);
    this.currentSetting = value / stepSize;
  }


  public getMinExposureOffset(captureSession: camera.PhotoSession | camera.VideoSession): number {
    return CameraUtils.getMinExposureBias(captureSession);
  }

  public getMaxExposureOffset(captureSession: camera.PhotoSession | camera.VideoSession): number {
    return CameraUtils.getMaxExposureBias(captureSession);
  }

  public getExposureOffsetStepSize(captureSession: camera.PhotoSession | camera.VideoSession): number {
    return CameraUtils.getExposureBiasStep(captureSession);
  }
}