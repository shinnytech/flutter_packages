// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on NoiseReductionFeature.java originally written by
// Copyright 2013 The Flutter Authors.

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