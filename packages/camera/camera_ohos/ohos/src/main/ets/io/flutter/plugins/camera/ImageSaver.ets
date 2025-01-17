// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ImageSaver.java originally written by
// Copyright 2013 The Flutter Authors.

import image from '@ohos.multimedia.image';
import fs from '@ohos.file.fs';

export interface ImageSaverCallback {
  onComplete(absolutePath: string): void;

  onError(errorCode: string, errorMessage: string): void;
}

export class ImageSaver {
  private readonly image: image.Image;
  private readonly file: fs.File | null;
  private readonly callback: ImageSaverCallback;

  constructor(image: image.Image, file: fs.File | null, callback: ImageSaverCallback) {
    this.image = image;
    this.file = file;
    this.callback = callback;
  }

  public run(): void {
    // todo:

  }
}