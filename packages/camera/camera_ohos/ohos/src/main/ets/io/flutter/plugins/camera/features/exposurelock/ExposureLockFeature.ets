// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ExposureLockFeature.java originally written by
// Copyright 2013 The Flutter Authors.

import { camera } from '@kit.CameraKit';
import { CameraFeature } from '../CameraFeature';
import { CameraProperties } from '../../CameraProperties';
import { ExposureMode } from './ExposureMode';

export class ExposureLockFeature extends CameraFeature<camera.ExposureMode> {
  private currentSetting: camera.ExposureMode = camera.ExposureMode.EXPOSURE_MODE_AUTO;

  constructor(cameraProperties: CameraProperties) {
    super(cameraProperties)
  }

  public getDebugName(): string {
    return "ExposureLockFeature";
  }

  public getValue(): camera.ExposureMode {
    return this.currentSetting;
  }

  public setValue(value: camera.ExposureMode): void {
    this.currentSetting = value;
  }

  public checkIsSupported(): boolean {
    return true;
  }
}