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

export class CameraCaptureProperties {
  private lastLensAperture: number = 0;
  private lastSensorExposureTime: number = 0;
  private lastSensorSensitivity: number = 0;

  public getLastLensAperture(): number {
    return this.lastLensAperture;
  }

  public setLastLensAperture(lastLensAperture: number) {
    this.lastLensAperture = lastLensAperture;
  }

  public getLastSensorExposureTime(): number {
    return this.lastSensorExposureTime;
  }

  public setLastSensorExposureTime(lastSensorExposureTime: number) {
    this.lastSensorExposureTime = lastSensorExposureTime;
  }

  public getLastSensorSensitivity(): number {
    return this.lastSensorSensitivity;
  }

  public setLastSensorSensitivity(lastSensorSensitivity: number) {
    this.lastSensorSensitivity = lastSensorSensitivity;
  }
}