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