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

import { CameraState } from './CameraState';
import { CameraCaptureProperties } from './types/CameraCaptureProperties';
import { CaptureTimeoutsWrapper } from './types/CaptureTimeoutsWrapper';


export class CameraCaptureCallback {
  private static TAG: String = "CameraCaptureCallback";
  private cameraStateListener: CameraCaptureStateListener;
  private cameraState: CameraState;
  private captureTimeouts: CaptureTimeoutsWrapper;
  private captureProps: CameraCaptureProperties;

  // Lookup keys for state; overrideable for unit tests since Mockito can't mock them.
  // aeStateKey: CaptureResult.Key<Number> = CaptureResult.CONTROL_AE_STATE;
  // afStateKey: CaptureResult.Key<Number> = CaptureResult.CONTROL_AF_STATE;

  constructor(
    cameraStateListener: CameraCaptureStateListener,
    captureTimeouts: CaptureTimeoutsWrapper,
    captureProps: CameraCaptureProperties) {
    this.cameraState = CameraState.STATE_PREVIEW;
    this.cameraStateListener = cameraStateListener;
    this.captureTimeouts = captureTimeouts;
    this.captureProps = captureProps;
  }

  static create(
    cameraStateListener: CameraCaptureStateListener,
    captureTimeouts: CaptureTimeoutsWrapper,
    captureProps: CameraCaptureProperties): CameraCaptureCallback {
    return new CameraCaptureCallback(cameraStateListener, captureTimeouts, captureProps);
  }

  public getCameraState(): CameraState {
    return this.cameraState;
  }

  public setCameraState(state: CameraState) {
    this.cameraState = state;
  }
}

export interface CameraCaptureStateListener {

  onConverged(): void;

  onPrecapture(): void;
}