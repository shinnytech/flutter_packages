// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraCaptureCallback.java originally written by
// Copyright 2013 The Flutter Authors.

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