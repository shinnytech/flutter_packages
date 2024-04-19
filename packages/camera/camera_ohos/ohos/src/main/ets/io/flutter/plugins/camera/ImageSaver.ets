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