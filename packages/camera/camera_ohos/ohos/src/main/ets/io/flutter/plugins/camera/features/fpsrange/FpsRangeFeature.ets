// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on FpsRangeFeature.java originally written by
// Copyright 2013 The Flutter Authors.

import { CameraFeature } from '../CameraFeature';
import util from '@ohos.util';

export class FpsRangeFeature extends CameraFeature<util.ScopeHelper>{
  public getDebugName(): string {
    return "FpsRangeFeature";
  }

  public getValue(): util.ScopeHelper {
    throw new Error('Method not implemented.');
  }

  public setValue(value: util.ScopeHelper): void {
    // todo
  }

  public checkIsSupported(): boolean {
     // todo:
    return true;
  }

  // android Range对应ohos什么?待完善

}