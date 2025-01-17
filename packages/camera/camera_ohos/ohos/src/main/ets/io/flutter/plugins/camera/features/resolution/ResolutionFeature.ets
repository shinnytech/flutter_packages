// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ResolutionFeature.java originally written by
// Copyright 2013 The Flutter Authors.

import camera from '@ohos.multimedia.camera';
import { CameraFeature } from '../CameraFeature';
import { ResolutionPreset } from './ResolutionPreset';
import { CameraProperties } from '../../CameraProperties';


export class ResolutionFeature extends CameraFeature<ResolutionPreset> {
  private captureSize: camera.Size = { width: 1920, height: 1080 } as camera.Size;
  private previewSize: camera.Size = { width: 1920, height: 1080 } as camera.Size;
  private currentSetting: ResolutionPreset;
  private cameraId: string | null;

  constructor(
    cameraProperties: CameraProperties,
    resolutionPreset: ResolutionPreset,
    cameraName: string) {
    super(cameraProperties);
    this.currentSetting = resolutionPreset;

    if (cameraName == null) {
      this.cameraId = null;
      return;
    }

    this.cameraId = cameraName;
  }

  public getPreviewSize(): camera.Size {
    return this.previewSize;
  }

  public getCaptureSize(): camera.Size {
    return this.captureSize;
  }

  public getDebugName(): string {
    return "ResolutionFeature";

  }

  public setValue(value: ResolutionPreset): void {
    this.currentSetting = value;
  }

  public getValue(): ResolutionPreset {
    return this.currentSetting;
  }

  public checkIsSupported(): boolean {
    return this.cameraId != null;
  }
}
