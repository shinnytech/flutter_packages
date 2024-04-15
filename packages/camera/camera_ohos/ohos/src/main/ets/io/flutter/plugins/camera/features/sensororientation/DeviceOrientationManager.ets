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

import Ability from '@ohos.app.ability.Ability';
import { DartMessenger } from '../../DartMessenger';
import display from '@ohos.display';

import { BusinessError, Callback } from '@ohos.base';

import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';

const handleOrientationChange = (
  newOrientation: DeviceOrientation,
  previousOrientation: DeviceOrientation,
  messenger: DartMessenger) => {
  if (newOrientation !== previousOrientation) {
    messenger.sendDeviceOrientationChangeEvent(newOrientation);
  }
}


export class DeviceOrientationManager {
  // private static readonly orientationIntentFilter: IntentFilter =
  //   new IntentFilter(Intent.ACTION_CONFIGURATION_CHANGED);
  private readonly ability: Ability;
  private readonly messenger: DartMessenger;
  private readonly isFrontFacing: boolean;
  private readonly sensorOrientation: number;
  private lastOrientation: DeviceOrientation = DeviceOrientation.PORTRAIT_UP;
  private displayClass: display.Display | null = null;


  public static create(
    ability: Ability,
    messenger: DartMessenger,
    isFrontFacing: boolean,
    sensorOrientation: number
  ): DeviceOrientationManager {
    return new DeviceOrientationManager(ability, messenger, isFrontFacing, sensorOrientation);
  }

  constructor(
    ability: Ability,
    messenger: DartMessenger,
    isFrontFacing: boolean,
    sensorOrientation: number) {
    this.ability = ability;
    this.messenger = messenger;
    this.isFrontFacing = isFrontFacing;
    this.sensorOrientation = sensorOrientation;
  }

  public start() {
    let callback: Callback<number> = (data: number) => {
      this.handleUIOrientationChange();
    };
    display.on('change', callback)
  }

  public stop() {
    display.off('change');
    this.displayClass = null;
  }

  public getPhotoOrientation(orientation?: DeviceOrientation) {
    if (orientation === undefined) {
      return this.lastOrientation;
    }
    let angle: number = 0;
    if (orientation == null) {
      orientation = this.getUIOrientation();
    }
    switch (orientation) {
      case DeviceOrientation.PORTRAIT_UP:
        angle = 90;
        break;
      case DeviceOrientation.PORTRAIT_DOWN:
        angle = 270;
        break;
      case DeviceOrientation.LANDSCAPE_LEFT:
        angle = this.isFrontFacing ? 180 : 0;
        break;
      case DeviceOrientation.LANDSCAPE_RIGHT:
        angle = this.isFrontFacing ? 0 : 180;
        break;
    }
    return (angle + this.sensorOrientation + 270) % 360;
  }


  public getVideoOrientation(orientation?: DeviceOrientation): number {


    let angle: number = 0;

    // Fallback to device orientation when the orientation value is null.
    if (orientation == null) {
      orientation = this.getUIOrientation();
    }

    switch (orientation) {
      case DeviceOrientation.PORTRAIT_UP:
        angle = 0;
        break;
      case DeviceOrientation.PORTRAIT_DOWN:
        angle = 180;
        break;
      case DeviceOrientation.LANDSCAPE_LEFT:
        angle = 270;
        break;
      case DeviceOrientation.LANDSCAPE_RIGHT:
        angle = 90;
        break;
    }

    if (this.isFrontFacing) {
      angle *= -1;
    }

    return (angle + this.sensorOrientation + 360) % 360;
  }

  public getLastUIOrientation(): DeviceOrientation {
    return this.lastOrientation;
  }

  handleUIOrientationChange() {
    let orientation: DeviceOrientation = this.getUIOrientation();
    handleOrientationChange(orientation, this.lastOrientation, this.messenger);
    this.lastOrientation = orientation;
  }


  getUIOrientation(): DeviceOrientation {
    const rotation: number | undefined = display.getDefaultDisplaySync().rotation;
    const orientation: display.Orientation | undefined = display.getDefaultDisplaySync().orientation
    switch (orientation) {
      case display.Orientation.PORTRAIT:
        if (rotation == 0 || rotation == 90) {
          return DeviceOrientation.PORTRAIT_UP;
        } else {
          return DeviceOrientation.PORTRAIT_DOWN;
        }
      case display.Orientation.LANDSCAPE:
        if (rotation == 0 || rotation == 90) {
          return DeviceOrientation.LANDSCAPE_LEFT;
        } else {
          return DeviceOrientation.LANDSCAPE_RIGHT;
        }
      case display.Orientation.PORTRAIT_INVERTED:
        if (rotation == 0 || rotation == 90) {
          return DeviceOrientation.PORTRAIT_UP;
        } else {
          return DeviceOrientation.PORTRAIT_DOWN;
        }
      case display.Orientation.LANDSCAPE_INVERTED:
        if (rotation == 0 || rotation == 90) {
          return DeviceOrientation.LANDSCAPE_RIGHT;
        } else {
          return DeviceOrientation.LANDSCAPE_LEFT;
        }
      default:
        return DeviceOrientation.PORTRAIT_UP;
    }
  }
  // getDeviceDefaultOrientation():number{
  //    Configuration config = activity.getResources().getConfiguration();
  //   int rotation = getDisplay().getRotation();
  //   if (((rotation == Surface.ROTATION_0 || rotation == Surface.ROTATION_180)
  //           && config.orientation == Configuration.ORIENTATION_LANDSCAPE)
  //       || ((rotation == Surface.ROTATION_90 || rotation == Surface.ROTATION_270)
  //           && config.orientation == Configuration.ORIENTATION_PORTRAIT)) {
  //     return Configuration.ORIENTATION_LANDSCAPE;
  //   } else {
  //     return Configuration.ORIENTATION_PORTRAIT;
  //   }
  // }


}