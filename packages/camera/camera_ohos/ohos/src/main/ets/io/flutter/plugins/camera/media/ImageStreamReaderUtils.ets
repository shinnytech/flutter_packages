// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ImageStreamReaderUtils.java originally written by
// Copyright 2013 The Flutter Authors.

import { ByteBuffer } from '@ohos/flutter_ohos';
import image from '@ohos.multimedia.image';

export class ImageStreamReaderUtils{
  public yuv420ThreePlanesToNv21(_image: image.Image, width: number, height: number): ByteBuffer {
    let imageSize: number = width * height;
    let out: Array<ArrayBuffer> = new ByteBuffer[imageSize + 2 * (imageSize / 4)];
    // let out: ArrayBuffer = new ArrayBuffer(imageSize + 2 * (imageSize / 4));

    // if (this.areUVPlanesNV21(_image, width, height)) {
    //   _image.getComponent(0).then((component : image.Component) => {
    //       out.splice(0, 0, component.byteBuffer.slice(0, imageSize))
    //   })
    //   _image.getComponent(1).then((component : image.Component) => {
    //     out.splice(imageSize, 0, component.byteBuffer)
    //   })
    //   _image.getComponent(2).then((component : image.Component) => {
    //     out.splice(imageSize, 0, component.byteBuffer.slice(0, imageSize))
    //   })
    // } else {
    //
    // }

    return ByteBuffer.from(out.pop());
  }

  private areUVPlanesNV21(_image: image.Image, width: number, height: number): boolean {
    return true
  }

  private unpackPlane(_image: image.Image, width: number, height: number, out: ArrayBuffer, offset: number, pixelStride: number): void {

  }
}