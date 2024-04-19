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
import { CameraCaptureProperties } from '../types/CameraCaptureProperties';
import { ImageStreamReaderUtils } from './ImageStreamReaderUtils';
import { ArrayList, HashMap } from '@kit.ArkTS';
import { Size } from '@kit.ArkUI';
import { EventSink, StreamHandler } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import { ByteBuffer } from '@ohos/flutter_ohos';

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

  public onImageAvailable(
    _image: image.Image,
    captureProps: CameraCaptureProperties,
    imageStreamSink: EventSink): void {
    try {
      let imageBuffer: HashMap<string, Object> = new HashMap();

      if(this.dartImageFormat == image.ImageFormat.YCBCR_422_SP) {
        imageBuffer.set("planes", this.parsePlanesForYuvOrJpeg(_image))
      } else{
        imageBuffer.set("planes", this.parsePlanesForYuvOrJpeg(_image))
      }

      imageBuffer.set('width', _image.size.width);
      imageBuffer.set('height', _image.size.height);
      imageBuffer.set('format', this.dartImageFormat);
      imageBuffer.set('lensAperture', captureProps.getLastLensAperture());
      imageBuffer.set('sensorExposureTime', captureProps.getLastSensorSensitivity());
      let sensorSensitivity: number = captureProps.getLastSensorSensitivity();
      imageBuffer.set('sensorSensitivity', sensorSensitivity == null ? null : sensorSensitivity);

      imageStreamSink.success(imageBuffer)
      _image.release()

    } catch (e) {
      imageStreamSink.error(
        "IllegalStateException",
        "Caught IllegalStateException: " + e.getMessage(),
        null)
      _image.release()
    }
  }

  public parsePlanesForYuvOrJpeg(_image: image.Image): ArrayList<HashMap<string, object>> {
    let planes: ArrayList<HashMap<string, object>> = new ArrayList();

    Object.values(image.ComponentType).forEach(async (value) => {
      _image.getComponent(value as number).then((component: image.Component) => {
        let planeBuffer: HashMap<string, Object> = new HashMap<string, Object>();

        planeBuffer.set("bytesPerRow", component.rowStride);
        planeBuffer.set("bytesPerPixel", component.pixelStride);
        planeBuffer.set("bytes", component.byteBuffer);

        planes.add(planeBuffer)
      })
    })
    return planes;
  }

  public parsePlanesForYCBCR422SP(_image: image.Image): ArrayList<HashMap<string, object>> {
    let planes: ArrayList<HashMap<string, object>> = new ArrayList();
    let imageBuffer: Array<ArrayBuffer> = new Array();
    Object.values(image.ComponentType).forEach(async (value) => {
      _image.getComponent(value as number).then((component: image.Component) => {
        imageBuffer.push(component.byteBuffer);
      })
    })
    // let bytes: ByteBuffer = this.imageStreamReaderUtils.yuv420ThreePlanesToNv21(_image, _image.size.width, _image.size.height);
    let planeBuffer: HashMap<string, Object> = new HashMap<string, Object>();
    planeBuffer.set("bytesPerRow", _image.size.width);
    planeBuffer.set("bytesPerPixel", 1);
    // planeBuffer.set("bytes", bytes);
    planeBuffer.set("bytes", imageBuffer);
    planes.add(planeBuffer);
    return planes;
  }

  // public getSurface(): Surface {
  //   return this.imageReceiver.getReceivingSurfaceId();
  // }

  public async subscribeListener(captureProps: CameraCaptureProperties, imageStreamSink: EventSink): Promise<void> {
    const _image: image.Image = await this.imageReceiver.readNextImage()
    if(_image == null) return
    this.onImageAvailable(_image, captureProps, imageStreamSink)
  }

  public removeListener(): void {
    this.imageReceiver.release()
  }

  public close(): void {
    this.imageReceiver.release()
  }
}