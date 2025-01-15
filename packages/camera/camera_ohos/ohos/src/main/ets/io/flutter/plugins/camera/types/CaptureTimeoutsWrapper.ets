// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CaptureTimeoutsWrapper.java originally written by
// Copyright 2013 The Flutter Authors.

import { Timeout } from './Timeout';

export class CaptureTimeoutsWrapper {
  private preCaptureFocusing: Timeout;
  private preCaptureMetering: Timeout;
  private preCaptureFocusingTimeoutMs: number;
  private preCaptureMeteringTimeoutMs: number;

  constructor(preCaptureFocusingTimeoutMs: number, preCaptureMeteringTimeoutMs: number) {
    this.preCaptureFocusingTimeoutMs = preCaptureFocusingTimeoutMs;
    this.preCaptureMeteringTimeoutMs = preCaptureMeteringTimeoutMs;
    this.preCaptureFocusing = Timeout.create(preCaptureFocusingTimeoutMs);
    this.preCaptureMetering = Timeout.create(preCaptureMeteringTimeoutMs);
  }

  reset(): void {
    this.preCaptureFocusing = Timeout.create(this.preCaptureFocusingTimeoutMs);
    this.preCaptureMetering = Timeout.create(this.preCaptureMeteringTimeoutMs);
  }

  getPreCaptureFocusing(): Timeout {
    return this.preCaptureFocusing;
  }

  getPreCaptureMetering(): Timeout {
    return this.preCaptureMetering;
  }
}