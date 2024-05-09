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