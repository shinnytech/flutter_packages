// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on AutoFocusFeature.java originally written by
// Copyright 2013 The Flutter Authors.

import { CameraProperties } from '../../CameraProperties';
import { CameraFeature } from '../CameraFeature';
import camera from '@ohos.multimedia.camera';

export class AutoFocusFeature extends CameraFeature<camera.FocusMode> {
  private currentSetting: camera.FocusMode = camera.FocusMode.FOCUS_MODE_AUTO;
  private readonly recordingVideo: boolean;

  constructor(cameraProperties: CameraProperties, recordingVideo: boolean) {
    super(cameraProperties);
    this.recordingVideo = recordingVideo;
  }

  getDebugName(): string {
    return "AutoFocusFeature";
  }

  setValue(value: camera.FocusMode): void {
    this.currentSetting = value;
  }

  getValue(): camera.FocusMode {
    return this.currentSetting;
  }

  public checkIsSupported(): boolean {
    let modes: number[] = this.cameraProperties.getControlAutoFocusAvailableModes();
    const minFocus: number = this.cameraProperties.getLensInfoMinimumFocusDistance();

    let isFixedLength = minFocus == null || minFocus == 0;

    return!isFixedLength
      && !(modes.length == 0
        // || (modes.length == 1 && modes[0] == CameraCharacteristics.CONTROL_AF_MODE_OFF));
        || (modes.length == 1 && modes[0] == 0)); // ohos没有CameraCharacteristics，待完善
  }
}