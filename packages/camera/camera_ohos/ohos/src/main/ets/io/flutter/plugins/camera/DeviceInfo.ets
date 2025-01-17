// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on DeviceInfo.java originally written by
// Copyright 2013 The Flutter Authors.

// const BRAND: string = Build.BRAND;
// const MODEL: string = Build.MODEL;
const BRAND: string = 'Build.BRAND';// 暂时写成string，后面要改
const MODEL: string = 'Build.MODEL'; // 暂时写成string，后面要改

export class DeviceInfo {

  public getBrand(): string {
    return BRAND;
  }

  public getModel(): string {
    return MODEL;
  }
}