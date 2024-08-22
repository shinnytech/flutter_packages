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
import UIAbility from '@ohos.app.ability.UIAbility';
import { HashMap } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { BinaryMessenger, EventChannel, MethodCall, TextureRegistry } from '@ohos/flutter_ohos';
import MethodChannel, {
  MethodCallHandler,
  MethodResult
} from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { SurfaceTextureEntry } from '@ohos/flutter_ohos/src/main/ets/view/TextureRegistry';
import { Camera } from './Camera';
import { Point } from './features/Point';
import { CameraUtils } from './CameraUtils';
import { DartMessenger } from './DartMessenger';
import { CameraProperties } from './CameraProperties';
import { FlashMode } from './features/flash/FlashMode';
import { CameraPermissions } from './CameraPermissions';
import { FocusMode } from './features/autofocus/FocusMode';
import { CameraPropertiesImpl } from './CameraPropertiesImpl';
import { ExposureMode } from './features/exposurelock/ExposureMode';
import { CameraFeatureFactoryImpl } from './features/CameraFeatureFactoryImpl';
import { ResolutionPreset, ResolutionPreset_valueOf } from './types/ResolutionPreset';
import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';

const TAG: string = "MethodCallHandlerImpl";

const enum STATUS {
  DEFAULT,
  CREATE_ING,
  INITIALIZE_ING,
}

export class MethodCallHandlerImpl implements MethodCallHandler {
  private ability: UIAbility;
  private context: Context;
  private messenger: BinaryMessenger;
  private cameraPermissions: CameraPermissions;
  private textureRegistry: TextureRegistry;
  private methodChannel: MethodChannel;
  private imageStreamChannel: EventChannel;
  private camera: Camera | null = null;
  private flutterTexture: SurfaceTextureEntry | null = null;
  private textureId: number = -1;
  private curStatus: STATUS = STATUS.DEFAULT;

  constructor(
    ability: UIAbility,
    messenger: BinaryMessenger,
    cameraPermissions: CameraPermissions,
    textureRegistry: TextureRegistry) {
    this.ability = ability;
    this.context = ability.context;
    this.messenger = messenger
    this.cameraPermissions = cameraPermissions;
    this.textureRegistry = textureRegistry;

    this.methodChannel = new MethodChannel(messenger, 'plugins.flutter.io/camera_ohos');
    this.imageStreamChannel =
      new EventChannel(messenger, 'plugins.flutter.io/camera_ohos/imageStream');
    this.methodChannel.setMethodCallHandler(this);
  }

  public onMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, 'onMethodCall', call.method);
    switch (call.method) {
      case 'availableCameras': {
        try {
          result.success(CameraUtils.getAvailableCameras(this.context))
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'create': {
        if (this.curStatus != STATUS.DEFAULT) {
          result.success(null);
          return;
        }
        this.curStatus = STATUS.CREATE_ING;
        if (this.camera) {
          this.camera.releaseCamera();
        }
        if (this.textureId > -1) {
          this.unregisterTexture(this.textureId);
        }
        // 检查权限
        this.cameraPermissions.requestPermissions(
          this.context,
          false,
          (errCode: string | null, errDesc: string | null) => {
            if (errCode == null) {
              try {
                this.registerCameraTexture();
                this.instantiateCamera(call, result);
              } catch (e) {
                this.curStatus = STATUS.DEFAULT;
                this.handleException(e, result);
              }
            } else {
              this.curStatus = STATUS.DEFAULT;
              result.error(errCode, errDesc, null);
            }
          }
        );
        break;
      }
      case 'initialize':
        this.curStatus = STATUS.INITIALIZE_ING;
        if (this.camera != null) {
          try {
            this.camera.open(call.argument('imageFormatGroup'));
            this.curStatus = STATUS.DEFAULT;
            result.success(null)
          } catch (e) {
            this.curStatus = STATUS.DEFAULT;
            this.handleException(e, result)
          }
        } else {
          this.curStatus = STATUS.DEFAULT;
          result.error(
            "cameraNotFound",
            "Camera Not found. Please call the 'create' method before calling 'initialize",
            null);
        }
        break;
      case 'takePicture':
        this.camera!.takePicture(result);
        break;
      case 'prepareForVideoRecording': {
        result.success(null);
        break;
      }
      case 'startVideoRecording': {
        this.camera!.startVideoRecording(result, this.imageStreamChannel);
        break;
      }
      case 'stopVideoRecording': {
        this.camera!.stopVideoRecording(result);
        break;
      }
      case 'pauseVideoRecording': {
        this.camera!.pauseVideoRecording(result);
        break;
      }
      case 'resumeVideoRecording': {
        {
          this.camera!.resumeVideoRecording(result);
          break;
        }
      }
      case 'setFlashMode': {
        let modeStr: string = call.argument("mode");
        let mode: camera.FlashMode | null = FlashMode.getValueForString(modeStr);
        if (mode == null) {
          result.error("setFlashModeFailed", "Unknown flash mode " + modeStr, null);
          return;
        }
        try {
          this.camera!.setFlashMode(result, mode);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'setExposureMode': {
        let modeStr: string = call.argument('mode');
        let mode: camera.ExposureMode | null = ExposureMode.getValueForString(modeStr);
        if (mode == null) {
          result.error("setExposureModeFailed", "Unknown exposure mode " + modeStr, null);
          return;
        }
        try {
          this.camera!.setExposureMode(result, mode);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'setExposurePoint': {
        let reset: number = call.argument('reset');
        let x: number | null = null;
        let y: number | null = null;
        if (reset == null || !reset) {
          x = call.argument("x");
          y = call.argument("y");
        }
        try {
          this.camera!.getFocusMode(result)
          this.camera!.setExposurePoint(result, new Point(x, y));
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'getMinExposureOffset': {
        try {
          let mixExposureOffset: number = this.camera!.getMinExposureOffset();
          result.success(mixExposureOffset);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'getMaxExposureOffset': {
        try {
          let maxExposureOffset: number = this.camera!.getMaxExposureOffset();
          result.success(maxExposureOffset);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'getExposureOffsetStepSize': {
        try {
          let exposureOffsetStepSize: number = this.camera!.getExposureOffsetStepSize();
          result.success(exposureOffsetStepSize);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'setExposureOffset': {
        try {
          this.camera!.setExposureOffset(result, call.argument("offset"));
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'setFocusMode': {
        let modeStr: string = call.argument('mode');
        let mode: camera.FocusMode | null = FocusMode.getValueForString(modeStr);
        if (mode == null) {
          result.error("setFocusModeFailed", "Unknown focus mode " + modeStr, null);
          return;
        }
        try {
          this.camera!.setFocusMode(result, mode);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'setFocusPoint': {
        let reset: number = call.argument('reset');
        let x: number | null = null;
        let y: number | null = null;
        if (reset == null || !reset) {
          x = call.argument('x');
          y = call.argument('y');
        }
        try {
          this.camera!.setFocusPoint(result, new Point(x, y));
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'startImageStream': {
        try {
          this.camera!.startPreviewWithImageStream(this.imageStreamChannel);
          result.success(null);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'stopImageStream': {
        try {
          this.camera!.startPreview();
          result.success(null);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'getMaxZoomLevel': {
        if (this.camera == null) {
          return;
        }
        try {
          let maxZoomLevel: number = this.camera!.getMaxZoomLevel();
          result.success(maxZoomLevel);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'getMinZoomLevel': {
        if (this.camera == null) {
          return;
        }
        try {
          let minZoomLevel: number = this.camera!.getMinZoomLevel();
          result.success(minZoomLevel);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'setZoomLevel': {
        if (this.camera == null) {
          return;
        }
        let zoom: number | null = call.argument('zoom');
        if (zoom == null) {
          result.error(
            "ZOOM_ERROR", "setZoomLevel is called without specifying a zoom level.", null);
          return;
        }

        try {
          this.camera.setZoomLevel(result, zoom);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'lockCaptureOrientation': {
        let orientation: DeviceOrientation =
          CameraUtils.deserializeDeviceOrientation(call.argument("orientation"));
        try {
          this.camera!.lockCaptureOrientation(orientation);
          result.success(null);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'unlockCaptureOrientation': {
        try {
          this.camera!.unlockCaptureOrientation();
          result.success(null);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'pausePreview': {
        try {
          this.camera!.pausePreview(result);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'resumePreview': {
        try {
          this.camera!.resumePreview(result);
        } catch (e) {
          this.handleException(e, result);
        }
      }
        break;
      case 'setDescriptionWhileRecording': {
        try {
          let cameraName: string = call.argument('cameraName');
          let cameraProperties: CameraProperties =
            new CameraPropertiesImpl(cameraName, CameraUtils.getCameraManager(this.context));
          this.camera?.setDescriptionWhileRecording(result, cameraProperties);
        } catch (e) {
          this.handleException(e, result);
        }
        break;
      }
      case 'dispose': {
        this.unregisterTexture(call.argument('cameraId'));
        this.camera?.dispose();
        result.success(null);
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }

  private registerCameraTexture(): void {
    this.textureId = this.textureRegistry.getTextureId();
    this.flutterTexture = this.textureRegistry.registerTexture(this.textureId);
  }

  private unregisterTexture(textureId: number): void {
    this.textureRegistry!.unregisterTexture(textureId);
    this.textureId = -1;
  }

  stopListening(): void {
    this.methodChannel.setMethodCallHandler(null);
  }

  private instantiateCamera(call: MethodCall, result: MethodResult): void {
    let cameraName: string = call.argument('cameraName');
    let preset: string = call.argument('resolutionPreset');
    let enableAudio: boolean = call.argument('enableAudio');

    const dartMessenger: DartMessenger =
      new DartMessenger(this.messenger, this.textureId);
    const cameraProperties: CameraProperties =
      new CameraPropertiesImpl(cameraName, CameraUtils.getCameraManager(this.context));
    const resolutionPreset: ResolutionPreset = ResolutionPreset_valueOf(preset);

    this.camera =
      new Camera(
        this.ability,
        this.flutterTexture!,
        new CameraFeatureFactoryImpl(),
        dartMessenger,
        cameraProperties,
        resolutionPreset,
        enableAudio);

    const reply: HashMap<String, Object> = new HashMap();
    reply.set('cameraId', this.textureId);
    result.success(reply);
  }

  private handleException(error: BusinessError, result: MethodResult): void {
    if (Object.values(camera.CameraErrorCode).includes(error.code)) {
      result.error("CameraError", error.message, null);
      return;
    }
    throw error as Error;
  }
}