// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on ImageStreamReader.java originally written by
// Copyright 2013 The Flutter Authors.

import image from '@ohos.multimedia.image';
import { CameraCaptureProperties } from '../types/CameraCaptureProperties';
import { ImageStreamReaderUtils } from './ImageStreamReaderUtils';
import { ArrayList, HashMap } from '@kit.ArkTS';
import { Size } from '@kit.ArkUI';
import { EventSink } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import { BusinessError } from '@kit.BasicServicesKit';

export class ImageStreamReader {
  private readonly dartImageFormat: number;
  private readonly imageReceiver: image.ImageReceiver;
  private readonly imageStreamReaderUtils: ImageStreamReaderUtils;

  constructor(size: Size, imageFormat: number, maxImages: number) {
    this.dartImageFormat = imageFormat;
    this.imageReceiver =
      image.createImageReceiver(size, imageFormat, maxImages);
    this.imageStreamReaderUtils = new ImageStreamReaderUtils();
  }

  public async onImageAvailable(
    _image: image.Image,
    imgComponent: image.Component,
    captureProps: CameraCaptureProperties,
    imageStreamSink: EventSink) {
    try {
      let imageBuffer: HashMap<string, Object> = new HashMap();

      imageBuffer.set("planes", this.parsePlanes(_image, imgComponent))
      imageBuffer.set('width', _image.size.width);
      imageBuffer.set('height', _image.size.height);
      imageBuffer.set('format', this.dartImageFormat);
      imageBuffer.set('lensAperture', captureProps.getLastLensAperture());
      imageBuffer.set('sensorExposureTime', captureProps.getLastSensorSensitivity());
      let sensorSensitivity: number = captureProps.getLastSensorSensitivity();
      imageBuffer.set('sensorSensitivity', sensorSensitivity == null ? null : sensorSensitivity);

      imageStreamSink.success(imageBuffer)
      await _image.release()

    } catch (e) {
      imageStreamSink.error(
        "IllegalStateException",
        "Caught IllegalStateException: " + e.getMessage(),
        null)
      await _image.release()
    }
  }

  public parsePlanes(
    _image: image.Image,
    imgComponent: image.Component): ArrayList<HashMap<string, object>> {
    let planes: ArrayList<HashMap<string, object>> = new ArrayList();

    let planeBuffer: HashMap<string, Object> = new HashMap<string, Object>();
    planeBuffer.set("bytesPerRow", imgComponent.rowStride);
    planeBuffer.set("bytesPerPixel", imgComponent.pixelStride);
    planeBuffer.set("bytes", new Uint8Array(imgComponent.byteBuffer));
    planes.add(planeBuffer);

    return planes;
  }

  public getReceivingSurfaceId() {
    return this.imageReceiver.getReceivingSurfaceId();
  }

  public async subscribeListener(captureProps: CameraCaptureProperties, imageStreamSink: EventSink) {

    this.imageReceiver.on('imageArrival', () => {
      this.imageReceiver.readNextImage((err: BusinessError, nextImage: image.Image) => {
        if (err || nextImage === undefined) {
          console.error('readNextImage failed');
          return;
        }
        nextImage.getComponent(image.ComponentType.JPEG, (err: BusinessError, imgComponent: image.Component) => {
          if (err || imgComponent === undefined) {
            console.error('getComponent failed');
          }
          if (imgComponent && imgComponent.byteBuffer as ArrayBuffer) {
            this.onImageAvailable(nextImage, imgComponent, captureProps, imageStreamSink)
          } else {
            console.error('byteBuffer is null');
          }
        })
      })
    });
  }

  public removeListener(): void {
    this.imageReceiver.release()
  }

  public close(): void {
    this.imageReceiver.release()
  }
}