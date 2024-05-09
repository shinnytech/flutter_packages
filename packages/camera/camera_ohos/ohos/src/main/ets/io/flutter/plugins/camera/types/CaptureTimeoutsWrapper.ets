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