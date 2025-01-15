// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ExposureMode.java originally written by
// Copyright 2013 The Flutter Authors.

import camera from '@ohos.multimedia.camera';

export class ExposureMode {
  public static getValueForString(modeStr: string): camera.ExposureMode | null {
    switch (modeStr) {
      case 'auto':
        return camera.ExposureMode.EXPOSURE_MODE_AUTO;
      case 'locked':
        return camera.ExposureMode.EXPOSURE_MODE_LOCKED;
      default:
        return null;
    }
  }

  public static getValueForMode(mode: camera.ExposureMode): string {
    switch (mode) {
      case camera.ExposureMode.EXPOSURE_MODE_AUTO:
        return 'auto';
      case camera.ExposureMode.EXPOSURE_MODE_LOCKED:
        return 'locked';
      default:
        return 'auto';
    }
  }
}