// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on SensorOrientationFeature.java originally written by
// Copyright 2013 The Flutter Authors.

import camera from '@ohos.multimedia.camera';
import Ability from '@ohos.app.ability.Ability';
import { CameraFeature } from '../CameraFeature';
import { DartMessenger } from '../../DartMessenger';
import { CameraProperties } from '../../CameraProperties';
import {  DeviceOrientationManager } from './DeviceOrientationManager';
import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';

export class SensorOrientationFeature extends CameraFeature<number> {
  private currentSetting: number = 0;
  private readonly deviceOrientationListener: DeviceOrientationManager;
  private lockedCaptureOrientation: DeviceOrientation | null = null;

  constructor(
    cameraProperties: CameraProperties,
    ability: Ability,
    dartMessenger: DartMessenger) {
    super(cameraProperties);
    this.setValue(cameraProperties.getSensorOrientation());

    let isFrontFacing: boolean = cameraProperties.getLensFacing() == camera.CameraPosition.CAMERA_POSITION_FRONT;
    this.deviceOrientationListener =
      DeviceOrientationManager.create(ability, dartMessenger, isFrontFacing, this.currentSetting);
    this.deviceOrientationListener.start();
  }

  public getDebugName(): string {
    return "SensorOrientationFeature";
  }

  public getValue(): number {
    return this.currentSetting;
  }

  public setValue(value: number): void {
    this.currentSetting = value;
  }

  public checkIsSupported(): boolean {
    return true;
  }

  public getDeviceOrientationManager(): DeviceOrientationManager {
    return this.deviceOrientationListener;
  }

  public lockCaptureOrientation(orientation: DeviceOrientation) {
    this.lockedCaptureOrientation = orientation;
  }

  public unlockCaptureOrientation() {
    this.lockedCaptureOrientation = null;
  }

  public getLockedCaptureOrientation(): DeviceOrientation | null {
    return this.lockedCaptureOrientation;
  }
}