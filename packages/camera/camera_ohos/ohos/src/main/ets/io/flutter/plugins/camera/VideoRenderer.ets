// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on VideoRenderer.java originally written by
// Copyright 2013 The Flutter Authors.

export class VideoRenderer {
  private rotation: number = 0;

  public setRotation(rotation: number): void {
    this.rotation = rotation;
  }

  close() {

    // todo 待实现
  }
}