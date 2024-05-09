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

import { CameraProperties } from '../../CameraProperties';
import { CameraFeature } from '../CameraFeature';
import { Rect } from '@ohos.application.AccessibilityExtensionAbility';
import { CameraUtils } from '../../CameraUtils';
import camera from '@ohos.multimedia.camera';


const DEFAULT_ZOOM_LEVEL = 1.0;

export class ZoomLevelFeature extends CameraFeature<number> {
  private readonly hasSupport: boolean = false;
  private readonly sensorArraySize: Rect;
  private currentSetting: number = DEFAULT_ZOOM_LEVEL;
  private minimumZoomLevel: number = this.currentSetting;
  private readonly maximumZoomLevel: number;

  constructor(cameraProperties: CameraProperties) {
    super(cameraProperties);


    this.sensorArraySize = this.cameraProperties.getSensorInfoActiveArraySize();

    if (this.sensorArraySize == null) {
      this.maximumZoomLevel = this.minimumZoomLevel;
      this.hasSupport = false;
      return;
    }
    // this.minimumZoomLevel = CameraUtils.getMinZoomRatio(this.captureSession);
    // this.maximumZoomLevel = CameraUtils.getMaxZoomRatio(this.captureSession);

    this.minimumZoomLevel = 0;
    this.maximumZoomLevel = 1;

    this.hasSupport = this.maximumZoomLevel > this.minimumZoomLevel;
  }

  public getDebugName(): string {
    return "ZoomLevelFeature";
  }

  public getValue(): number {
    return this.currentSetting;
  }

  public setValue(value: number): void {
    this.currentSetting = value;
  }

  public checkIsSupported(): boolean {
    return this.hasSupport;
  }

  public getMinimumZoomLevel(captureSession: camera.PhotoSession | camera.VideoSession): number {
    return CameraUtils.getMinZoomRatio(captureSession);
  }

  public getMaximumZoomLevel(captureSession: camera.PhotoSession | camera.VideoSession): number {
    return CameraUtils.getMaxZoomRatio(captureSession);
  }
}