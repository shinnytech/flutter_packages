// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ExposureOffsetFeature.java originally written by
// Copyright 2013 The Flutter Authors.

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