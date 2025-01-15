// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraPropertiesImpl.java originally written by
// Copyright 2013 The Flutter Authors.

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