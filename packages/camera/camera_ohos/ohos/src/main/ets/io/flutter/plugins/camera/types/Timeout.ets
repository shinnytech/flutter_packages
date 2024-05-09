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

export class Timeout {
  private timeoutMs: number;
  private timeStarted: number;

  static create(timeoutMs: number): Timeout {
    return new Timeout(timeoutMs)
  }

  constructor(timeoutMs: number) {
    this.timeoutMs = timeoutMs;
    // this.timeStarted = SystemClock.elapsedRealtime();
    this.timeStarted = 1;
  }

  getIsExpired():boolean{
    // return (SystemClock.elapsedRealtime() - timeStarted) > timeoutMs;
    return false;
  }
}