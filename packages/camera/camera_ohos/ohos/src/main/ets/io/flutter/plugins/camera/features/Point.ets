// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on Point.java originally written by
// Copyright 2013 The Flutter Authors.

export class Point {
  public readonly x: number | null;
  public readonly y: number | null;

  constructor(x: number | null, y: number | null) {
    this.x = x;
    this.y = y;
  }
}