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
