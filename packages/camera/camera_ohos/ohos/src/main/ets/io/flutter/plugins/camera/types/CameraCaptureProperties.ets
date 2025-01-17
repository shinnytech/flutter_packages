// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraCaptureProperties.java originally written by
// Copyright 2013 The Flutter Authors.

export class CameraCaptureProperties {
  private lastLensAperture: number = 0;
  private lastSensorExposureTime: number = 0;
  private lastSensorSensitivity: number = 0;

  public getLastLensAperture(): number {
    return this.lastLensAperture;
  }

  public setLastLensAperture(lastLensAperture: number) {
    this.lastLensAperture = lastLensAperture;
  }

  public getLastSensorExposureTime(): number {
    return this.lastSensorExposureTime;
  }

  public setLastSensorExposureTime(lastSensorExposureTime: number) {
    this.lastSensorExposureTime = lastSensorExposureTime;
  }

  public getLastSensorSensitivity(): number {
    return this.lastSensorSensitivity;
  }

  public setLastSensorSensitivity(lastSensorSensitivity: number) {
    this.lastSensorSensitivity = lastSensorSensitivity;
  }
}