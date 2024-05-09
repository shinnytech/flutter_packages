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

import { HashMap } from '@kit.ArkTS';
import { MethodChannel } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { CameraUtils } from './CameraUtils';
import { FocusMode } from './features/autofocus/FocusMode';
import { ExposureMode } from './features/exposurelock/ExposureMode';
import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';

enum DeviceEventType {
  ORIENTATION_CHANGED = "orientation_changed",
}

enum CameraEventType {
  ERROR = "error",
  CLOSING = "camera_closing",
  INITIALIZED = "initialized",
}

export class DartMessenger {
  cameraChannel: MethodChannel;
  deviceChannel: MethodChannel;

  constructor(messenger: BinaryMessenger, cameraId: Number) {
    this.cameraChannel =
      new MethodChannel(messenger, "plugins.flutter.io/camera_ohos/camera" + cameraId);
    this.deviceChannel = new MethodChannel(messenger, "plugins.flutter.io/camera_ohos/fromPlatform");
  }

  sendDeviceOrientationChangeEvent(orientation: DeviceOrientation) {
    const args: HashMap<String, Object> = new HashMap();
    args.set('orientation', CameraUtils.serializeDeviceOrientation(orientation));
    this.sendDeviceEvent(DeviceEventType.ORIENTATION_CHANGED, args);
  }

  sendCameraInitializedEvent(
    previewWidth: number,
    previewHeight: number,
    exposureMode: ExposureMode,
    focusMode: FocusMode,
    exposurePointSupported: boolean,
    focusPointSupported: boolean) {
    if(previewWidth == null || previewHeight == null || exposureMode == null || focusMode == null ||exposurePointSupported==null || focusPointSupported == null){
      return;
    }

    let args: HashMap<String, Object> = new HashMap();
    args.set("previewWidth", previewWidth);
    args.set("previewHeight", previewHeight);
    args.set("exposureMode", 'auto');
    args.set("focusMode", 'auto');
    args.set("exposurePointSupported", exposurePointSupported);
    args.set("focusPointSupported", focusPointSupported);
    this.sendCameraEvent(CameraEventType.INITIALIZED, args);
  }

  sendCameraClosingEvent() {
    this.sendCameraEvent(CameraEventType.CLOSING);
  }

  sendCameraErrorEvent(description?: string) {
    const args: HashMap<String, Object> = new HashMap();
    if (description) {
      args.set('description', description);
    }
    this.sendCameraEvent(CameraEventType.ERROR, args);
  }

  sendCameraEvent(eventType: CameraEventType, args: HashMap<String, Object> = new HashMap()) {
    if (this.cameraChannel == null) {
      return;
    }
    this.cameraChannel.invokeMethod(eventType, args)
  }

  sendDeviceEvent(eventType: DeviceEventType, args: HashMap<String, Object> = new HashMap()) {
    if (this.deviceChannel == null) {
      return;
    }
    this.deviceChannel.invokeMethod(eventType, args)
  }

  finish(result: MethodResult, payload?: Object) {
    result.success(payload);
  }

  public error(
    result: MethodResult,
    errorCode: string,
    errorMessage?: string,
    errorDetails?: Object) {
    result.error(errorCode, errorMessage, errorDetails);
  }
}