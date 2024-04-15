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

import { CameraProperties } from './CameraProperties';
import { camera } from '@kit.CameraKit';
import { BusinessError } from '@ohos.base';
import { CameraUtils } from './CameraUtils';
import { Rect } from '@ohos.application.AccessibilityExtensionAbility';

export class CameraPropertiesImpl implements CameraProperties {
  // private cameraCharacteristics: CameraCharacteristics; //ohos没有对应实现，需要通过cameraDevice去找
  private cameraName: string;
  private cameraDevice: camera.CameraDevice;

  constructor(cameraName: string, cameraManager: camera.CameraManager) {
    this.cameraName = cameraName;
    this.cameraDevice = CameraUtils.getCameraDevice(cameraName, cameraManager);
  }

  getSensorInfoActiveArraySize(): Rect {
    // todo:
    return {} as Rect
  }

  getControlAutoExposureCompensationRange(captureSession: camera.PhotoSession | camera.VideoSession): Array<number> {
    let biasRangeArray: Array<number> = [];
    try {
      biasRangeArray = captureSession.getExposureBiasRange();
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The getExposureBiasRange call failed. error code: ${err.code}`);
    }
    return biasRangeArray;
  }

  getCameraName(): string {
    return this.cameraName;
  }

  getControlAutoExposureCompensationStep(): number {
    // todo:
    return 0;
  }

  getControlAutoFocusAvailableModes(): number[] {
    // todo:
    return [];
  }

  getControlMaxRegionsAutoExposure(): number {
    // todo:
    return 0;
  }

  getControlMaxRegionsAutoFocus(): number {
    // todo:
    return 0;
  }

  getDistortionCorrectionAvailableModes(): number[] {
    // todo:
    return [];
  }

  getFlashInfoAvailable(): boolean {
    // todo:
    return true;
  }

  getLensFacing(): number {
    // todo:
    return 0;
  }

  getLensInfoMinimumFocusDistance(): number {
     // todo:
    return 0;
  }

  getScalerAvailableMaxDigitalZoom(): number {
     // todo:
    return 0;
  }


  getSensorOrientation(): number {
     // todo:
    return 0;
  }

  getHardwareLevel(): number {
     // todo:
    return 0;
  }

  getAvailableNoiseReductionModes(): number[] {
     // todo:
    return [];
  }
}