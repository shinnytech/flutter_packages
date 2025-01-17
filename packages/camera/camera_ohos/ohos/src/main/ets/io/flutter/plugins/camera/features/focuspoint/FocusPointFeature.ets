// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on FocusPointFeature.java originally written by
// Copyright 2013 The Flutter Authors.

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