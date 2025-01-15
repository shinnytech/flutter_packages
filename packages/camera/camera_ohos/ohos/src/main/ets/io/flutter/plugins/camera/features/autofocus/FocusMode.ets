// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on FocusMode.java originally written by
// Copyright 2013 The Flutter Authors.

import camera from '@ohos.multimedia.camera';

export class FocusMode {
  public static getValueForString(modeStr: string): camera.FocusMode | null {
    switch (modeStr) {
      case 'auto':
        return camera.FocusMode.FOCUS_MODE_AUTO;
      case 'locked':
        return camera.FocusMode.FOCUS_MODE_LOCKED;
      default:
        return null;
    }
  }

  public static getValueForMode(mode: camera.FocusMode): string {
    switch (mode) {
      case camera.FocusMode.FOCUS_MODE_AUTO:
        return 'auto';
      case camera.FocusMode.FOCUS_MODE_LOCKED:
        return 'locked';
      default:
        return 'auto';
    }
  }
}
