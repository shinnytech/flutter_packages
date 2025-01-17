// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraRegionUtils.java originally written by
// Copyright 2013 The Flutter Authors.

import { Size } from '@kit.ArkUI';


export class CameraRegionUtils {
  // public static convertPointToMeteringRectangle(
  //   boundaries: Size, x: number, y: number, orientation: DeviceOrientation): MeteringRectangle {
  //   assertFalse(boundaries.width > 0 && boundaries.height > 0);
  //   assertFalse(x >= 0 && x <= 1);
  //   assertFalse(y >= 0 && y <= 1);
  //
  //   let oldX: number = x, oldY = y;
  //   switch (orientation) {
  //     case DeviceOrientation.PORTRAIT_UP:
  //       y = 1 - oldX;
  //       x = oldY;
  //       break;
  //     case DeviceOrientation.PORTRAIT_DOWN:
  //       x = 1 - oldY;
  //       y = oldX;
  //       break;
  //     case DeviceOrientation.LANDSCAPE_LEFT:
  //
  //       break;
  //     case DeviceOrientation.LANDSCAPE_RIGHT:
  //       x = 1 - x;
  //       y = 1 - y;
  //       break;
  //   }
  //
  //   let targetX:number =
  // }
}