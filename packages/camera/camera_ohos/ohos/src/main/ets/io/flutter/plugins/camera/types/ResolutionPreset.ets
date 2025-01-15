// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ResolutionPreset.java originally written by
// Copyright 2013 The Flutter Authors.

export enum ResolutionPreset {
  low,
  medium,
  high,
  veryHigh,
  ultraHigh,
  max,
}

export const ResolutionPreset_valueOf = (v: string): ResolutionPreset => {
  switch (v) {
    case 'low':
      return ResolutionPreset.low;
    case 'medium':
      return ResolutionPreset.medium;
    case 'high':
      return ResolutionPreset.high;
    case 'veryHigh':
      return ResolutionPreset.veryHigh;
    case 'ultraHigh':
      return ResolutionPreset.ultraHigh;
    case 'max':
      return ResolutionPreset.max;
    default:
      return ResolutionPreset.low;
  }
}
