// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraFeature.java originally written by
// Copyright 2013 The Flutter Authors.

import { CameraProperties } from '../CameraProperties'
import camera from '@ohos.multimedia.camera';

export abstract class CameraFeature<T> {
  protected cameraProperties: CameraProperties;

  constructor(cameraProperties: CameraProperties) {
    this.cameraProperties = cameraProperties;
  }

  public abstract getDebugName(): string;

  public abstract getValue(): T;

  public abstract setValue(value: T, captureSession?: camera.PhotoSession | camera.VideoSession);

  public abstract checkIsSupported(): boolean;

  // public abstract updateBuilder(requestBuilder: CaptureRequest.Builder);
}