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

import { Size } from '@kit.ArkUI';
import { Point } from '../Point';
import { CameraFeature } from '../CameraFeature';
import { CameraProperties } from '../../CameraProperties';
import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';
import { SensorOrientationFeature } from '../sensororientation/SensorOrientationFeature';

export class FocusPointFeature extends CameraFeature<Point> {
  private cameraBoundaries: Size | null = null;
  private focusPoint: Point | null = null;
  // private focusRectangle: MeteringRectangle;
  private readonly sensorOrientationFeature: SensorOrientationFeature;

  constructor(cameraProperties: CameraProperties, sensorOrientationFeature: SensorOrientationFeature) {
    super(cameraProperties);
    this.sensorOrientationFeature = sensorOrientationFeature;
  }

  public setCameraBoundaries(cameraBoundaries: Size) {
    this.cameraBoundaries = cameraBoundaries;
    this.buildFocusRectangle();
  }

  public getDebugName(): string {
    return "FocusPointFeature";
  }

  public getValue(): Point {
    return this.focusPoint == null ? new Point(null, null) : this.focusPoint; // todo:
  }

  public setValue(value: Point): void {
    this.focusPoint = value == null || value.x == null || value.y == null ? null : value;
    // this.buildFocusRectangle();
  }

  public checkIsSupported(): boolean {
    let supportedRegions: number = this.cameraProperties.getControlMaxRegionsAutoFocus();
    return supportedRegions != null && supportedRegions > 0;
  }

  private buildFocusRectangle() {
    if (this.cameraBoundaries == null) {
      throw new Error(
        "The cameraBoundaries should be set (using `FocusPointFeature.setCameraBoundaries(Size)`) before updating the focus point.");
    }
    if (this.focusPoint == null) {
      // this.focusRectangle = null;
    } else {
      let orientation: DeviceOrientation | null =
        this.sensorOrientationFeature.getLockedCaptureOrientation();
      if (orientation == null) {
        orientation =
          this.sensorOrientationFeature.getDeviceOrientationManager().getLastUIOrientation();
      }
      // this.focusRectangle =
      //   CameraRegionUtils.convertPointToMeteringRectangle(
      //     this.cameraBoundaries, this.focusPoint.x, this.focusPoint.y, orientation);
    }
  }
}