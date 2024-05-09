/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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