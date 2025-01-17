// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraProperties.java originally written by
// Copyright 2013 The Flutter Authors.

import camera from '@ohos.multimedia.camera';
import { Rect } from '@ohos.application.AccessibilityExtensionAbility';

export interface CameraProperties {

  getCameraName(): string;

  // getControlAutoExposureAvailableTargetFpsRanges(): Range<number>[];

  getControlAutoExposureCompensationRange(captureSession: camera.PhotoSession | camera.VideoSession): Array<number>;

  getControlAutoExposureCompensationStep(): number;

  getControlAutoFocusAvailableModes(): number[];

  getControlMaxRegionsAutoExposure(): number;

  getControlMaxRegionsAutoFocus(): number;

  getDistortionCorrectionAvailableModes(): number[];

  getFlashInfoAvailable(): boolean;

  getLensFacing(): number;

  getLensInfoMinimumFocusDistance(): number;

  getScalerAvailableMaxDigitalZoom(): number;


  getSensorInfoActiveArraySize(): Rect;
  //
  // getSensorInfoPixelArraySize(): Rect;
  //
  // getSensorInfoPreCorrectionActiveArraySize(): Rect;

  getSensorOrientation(): number;

  getHardwareLevel(): number;

  getAvailableNoiseReductionModes(): number[];
}
