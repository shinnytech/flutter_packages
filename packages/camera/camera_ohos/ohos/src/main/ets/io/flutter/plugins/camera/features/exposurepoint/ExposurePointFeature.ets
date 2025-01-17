// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ExposurePointFeature.java originally written by
// Copyright 2013 The Flutter Authors.

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