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

import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@ohos.base';
import { HashMap } from '@kit.ArkTS';
import DateTimeUtil from './utlis/DateTimeUtil';
import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';


interface FileInfo {
  prefix: string;
  suffix: string;
  directory: number;
}

const CameraDeviceMap = (cameraManager: camera.CameraManager): HashMap<string, camera.CameraDevice> => {
  const deviceMap: HashMap<string, camera.CameraDevice> = new HashMap();
  try {
    let cameras: Array<camera.CameraDevice> = [];
    cameras = cameraManager.getSupportedCameras();
    for (let element of cameras) {
      deviceMap.set(element.cameraId, element);
    }
  } catch (error) {
    let err = error as BusinessError;
    console.error(`The getSupportedCameras call failed. error code: ${err.code}`);
  }
  return deviceMap;
}

export class CameraUtils {

  constructor(context: Context) {
  }

  static getCameraManager(context: Context): camera.CameraManager {
    return camera.getCameraManager(context);
  }

  static getCameraDevice(cameraId: string, cameraManager: camera.CameraManager): camera.CameraDevice {
    return CameraDeviceMap(cameraManager).get(cameraId);
  }

  static getCameraInput(cameraDevice: camera.CameraDevice | undefined, cameraManager: camera.CameraManager): camera.CameraInput | undefined {
    let cameraInput: camera.CameraInput | undefined = undefined;
    try {
      cameraInput = cameraManager.createCameraInput(cameraDevice);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`The createCameraInput call failed. error code: ${err.code}`);
    }
    return cameraInput;
  }


  static serializeDeviceOrientation(orientation: DeviceOrientation): string {
    if (orientation == null)
      throw new Error("Could not serialize null device orientation.");
    switch (orientation) {
      case DeviceOrientation.PORTRAIT_UP:
        return "portraitUp";
      case DeviceOrientation.PORTRAIT_DOWN:
        return "portraitDown";
      case DeviceOrientation.LANDSCAPE_LEFT:
        return "landscapeLeft";
      case DeviceOrientation.LANDSCAPE_RIGHT:
        return "landscapeRight";
      default:
        throw new Error(
          "Could not serialize device orientation: " + String(orientation));
    }
  }

  static deserializeDeviceOrientation(orientation: string): DeviceOrientation {
    if (orientation == null)
      throw new Error("Could not deserialize null device orientation.");
    switch (orientation) {
      case "portraitUp":
        return DeviceOrientation.PORTRAIT_UP;
      case "portraitDown":
        return DeviceOrientation.PORTRAIT_DOWN;
      case "landscapeLeft":
        return DeviceOrientation.LANDSCAPE_LEFT;
      case "landscapeRight":
        return DeviceOrientation.LANDSCAPE_RIGHT;
      default:
        throw new Error(
          "Could not deserialize device orientation: " + orientation);
    }
  }

  static getAvailableCameras(context: Context): Array<Map<String, Object>> {
    let cameraArray: Array<Map<String, Object>> = [];
    try {
      const cameraManager: camera.CameraManager = camera.getCameraManager(context);
      let cameras: Array<camera.CameraDevice> = [];
      cameras = cameraManager.getSupportedCameras();

      for (let element of cameras) {
        const details: Map<String, Object> = new Map<String, Object>();
        details.set('name', element.cameraId);
        details.set('sensorOrientation', camera.ImageRotation.ROTATION_0);

        let position: camera.CameraPosition = element.cameraPosition;
        switch (position) {
          case camera.CameraPosition.CAMERA_POSITION_UNSPECIFIED:
            details.set('lensFacing', 'external');
            break;
          case camera.CameraPosition.CAMERA_POSITION_BACK:
            details.set('lensFacing', 'back');
            break;
          case camera.CameraPosition.CAMERA_POSITION_FRONT:
            details.set('lensFacing', 'front');
            break;
          case camera.CameraPosition.CAMERA_POSITION_FOLD_INNER:
            details.set('lensFacing', 'external');
            break;
        }
        cameraArray.push(details);
      }
    } catch (error) {
      let err = error as BusinessError;
      console.error(`The getAvailableCameras call failed. error code: ${err.code}`);
    }
    return cameraArray;
  }

  static getSupportedOutputCapability(device: camera.CameraDevice, mode: camera.SceneMode, manager: camera.CameraManager): camera.CameraOutputCapability {
    let capability: camera.CameraOutputCapability = manager.getSupportedOutputCapability(device, mode);
    return capability;
  }

  //检测是否有闪光灯
  public static hasFlash(captureSession: camera.PhotoSession | camera.VideoSession): boolean {
    let status: boolean = false;
    try {
      status = captureSession.hasFlash();
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The hasFlash call failed. error code: ${err.code}`);
    }
    return status;
  }

  //检测闪光灯模式是否支持
  public static isFlashModeSupported(captureSession: camera.PhotoSession | camera.VideoSession, mode: camera.FlashMode): boolean {
    let status: boolean = false;
    try {
      status = captureSession.isFlashModeSupported(mode);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The isFlashModeSupported call failed. error code: ${err.code}`);
    }
    return status;
  }

  // 检测曝光模式是否支持
  public static isExposureModeSupported(captureSession: camera.PhotoSession | camera.VideoSession, mode: camera.ExposureMode): boolean {
    let isSupported: boolean = false;
    try {
      isSupported = captureSession.isExposureModeSupported(mode);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The isExposureModeSupported call failed. error code: ${err.code}`);
    }
    return isSupported;
  }

  // 获取支持的变焦范围
  public static getZoomRatioRange(captureSession: camera.PhotoSession | camera.VideoSession): Array<number> {
    let zoomRatioRange: Array<number> = [];
    try {
      zoomRatioRange = captureSession.getZoomRatioRange();
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The getZoomRatioRange call failed. error code: ${err.code}`);
    }
    return zoomRatioRange;
  }

  // 获取支持的最小变焦范围
  public static getMinZoomRatio(captureSession: camera.PhotoSession | camera.VideoSession): number {
    let minZoomRatio: number = -10;
    try {
      let zoomRatioRange: Array<number> = captureSession.getZoomRatioRange();
      minZoomRatio = Math.min(...zoomRatioRange);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The getZoomRatioRange call failed. error code: ${err.code}`);
    }
    return minZoomRatio;
  }

  // 获取支持的最大变焦范围
  public static getMaxZoomRatio(captureSession: camera.PhotoSession | camera.VideoSession): number {
    let maxZoomRatio: number = 10;
    try {
      let zoomRatioRange: Array<number> = captureSession.getZoomRatioRange();
      maxZoomRatio = Math.max(...zoomRatioRange);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The getZoomRatioRange call failed. error code: ${err.code}`);
    }
    return maxZoomRatio;
  }

  // 查询曝光补偿范围
  public static getExposureBiasRange(captureSession: camera.PhotoSession | camera.VideoSession): Array<number> {
    let biasRangeArray: Array<number> = [];
    try {
      biasRangeArray = captureSession.getExposureBiasRange();
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The getExposureBiasRange call failed. error code: ${err.code}`);
    }
    return biasRangeArray;
  }

  // 查询最小曝光补偿值
  public static getMinExposureBias(captureSession: camera.PhotoSession | camera.VideoSession): number {
    let minExposure: number = -10;
    try {
      let biasRangeArray = captureSession.getExposureBiasRange();
      if (biasRangeArray.length > 1) {
        minExposure = biasRangeArray[0];
      }
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The getExposureBiasRange call failed. error code: ${err.code}`);
    }
    return minExposure;
  }

  // 查询最大曝光补偿值
  public static getMaxExposureBias(captureSession: camera.PhotoSession | camera.VideoSession): number {
    let maxExposure: number = 10;
    try {
      let biasRangeArray = captureSession.getExposureBiasRange();
      if (biasRangeArray.length > 1) {
        maxExposure = biasRangeArray[biasRangeArray.length-1];
      }
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The getExposureBiasRange call failed. error code: ${err.code}`);
    }
    return maxExposure;
  }


  // 查询曝光补偿值步长
  public static getExposureBiasStep(captureSession: camera.PhotoSession | camera.VideoSession): number {
    return 0.5;
  }
}