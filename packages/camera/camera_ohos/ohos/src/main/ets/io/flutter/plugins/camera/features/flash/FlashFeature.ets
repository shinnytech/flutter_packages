// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on FlashFeature.java originally written by
// Copyright 2013 The Flutter Authors.

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