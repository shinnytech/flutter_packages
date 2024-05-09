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

import { CameraProperties } from '../../CameraProperties';
import { CameraFeature } from '../CameraFeature';
import { Point } from '../Point';
import { SensorOrientationFeature } from '../sensororientation/SensorOrientationFeature';
import { Size } from '@kit.ArkUI';
import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';
import camera from '@ohos.multimedia.camera';
import { Rect } from '@ohos.UiTest';

export class ExposurePointFeature extends CameraFeature<Point> {
  private cameraBoundaries: Size | null = null;
  private exposurePoint: Point = new Point(null, null);
  private exposureRectangle: camera.Rect | null = null;
  private readonly sensorOrientationFeature: SensorOrientationFeature;
  private defaultRegionsHasBeenSet: boolean = false;
  public defaultRegions: camera.Rect[] | null = null;

  constructor(
    cameraProperties: CameraProperties,
    sensorOrientationFeature: SensorOrientationFeature) {
    super(cameraProperties);
    this.sensorOrientationFeature = sensorOrientationFeature;
  }

  public setCameraBoundaries(cameraBoundaries: Size) {
    this.cameraBoundaries = cameraBoundaries;
    this.buildExposureRectangle();
  }

  public getDebugName(): string {
    return "ExposurePointFeature";
  }

  public getValue(): Point {
    return this.exposurePoint;
  }

  public setValue(value: Point): void {
    this.exposurePoint = (value == null || value.x == null || value.y == null) ? new Point(null, null) : value;
    // this.buildExposureRectangle();
  }

  public checkIsSupported(): boolean {
    let supportedRegions = this.cameraProperties.getControlMaxRegionsAutoExposure();
    return supportedRegions != null && supportedRegions > 0;
  }

  public updateBuilder(): void {
    // todo:??

  }

  private buildExposureRectangle() {
    if (this.cameraBoundaries == null) {
      throw new Error(
        "The cameraBoundaries should be set (using `ExposurePointFeature.setCameraBoundaries(Size)`) before updating the exposure point.");
    }
    if (this.exposurePoint == null) {
      this.exposureRectangle = null;
    } else {
      let orientation: DeviceOrientation | null =
        this.sensorOrientationFeature.getLockedCaptureOrientation();
      if (orientation == null) {
        orientation =
          this.sensorOrientationFeature.getDeviceOrientationManager().getLastUIOrientation();
      }
      this.exposureRectangle =
        this.convertPointToMeteringRectangle(
          this.cameraBoundaries, this.exposurePoint.x, this.exposurePoint.y, orientation);
    }
  }

  // todo: ohos暂未找到对应实现，找不到就对着android写一下
  private convertPointToMeteringRectangle(
    boundaries: Size,
    x: number | null,
    y: number | null,
    orientation: DeviceOrientation): camera.Rect {
    return { topLeftX:0,topLeftY:0,width:0,height:0}
  }
}