// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on FlashMode.java originally written by
// Copyright 2013 The Flutter Authors.

import camera from '@ohos.multimedia.camera';

export class FlashMode {
  public static getValueForString(modeStr: string): camera.FlashMode | null {
    switch (modeStr) {
      case 'off':
        return camera.FlashMode.FLASH_MODE_CLOSE;
      case 'auto':
        return camera.FlashMode.FLASH_MODE_AUTO;
      case 'always':
        return camera.FlashMode.FLASH_MODE_OPEN;
      case 'torch':
        return camera.FlashMode.FLASH_MODE_ALWAYS_OPEN;
      default:
        return null;
    }
  }

  public static getValueForMode(mode: camera.FlashMode): string {
    switch (mode) {
      case camera.FlashMode.FLASH_MODE_CLOSE:
        return 'off';
      case camera.FlashMode.FLASH_MODE_AUTO:
        return 'auto';
      case camera.FlashMode.FLASH_MODE_OPEN:
        return 'always';
      case camera.FlashMode.FLASH_MODE_ALWAYS_OPEN:
        return 'torch';
      default:
        return 'auto';
    }
  }
}