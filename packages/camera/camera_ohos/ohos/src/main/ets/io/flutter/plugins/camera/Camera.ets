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

import { media } from '@kit.MediaKit';
import fs from '@ohos.file.fs';
import Ability from '@ohos.app.ability.Ability';
import UIAbility from '@ohos.app.ability.UIAbility';
import camera from '@ohos.multimedia.camera';
import image from '@ohos.multimedia.image';
import { HashMap, List } from '@kit.ArkTS';
import { EventChannel, Log } from '@ohos/flutter_ohos';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { SurfaceTextureEntry } from '@ohos/flutter_ohos/src/main/ets/view/TextureRegistry';
import { CameraFeatureFactory } from './features/CameraFeatureFactory';
import { DartMessenger } from './DartMessenger';
import { CameraProperties } from './CameraProperties';
import { ResolutionPreset } from './types/ResolutionPreset';
import { CameraCaptureCallback, CameraCaptureStateListener } from './CameraCaptureCallback';
import { CameraFeatures } from './features/CameraFeatures';
import { CaptureTimeoutsWrapper } from './types/CaptureTimeoutsWrapper';
import { CameraCaptureProperties } from './types/CameraCaptureProperties';
import { ResolutionFeature } from './features/resolution/ResolutionFeature';
import { CameraUtils } from './CameraUtils';
import { VideoRenderer } from './VideoRenderer';
import { ImageStreamReader } from './media/ImageStreamReader';
import { BusinessError } from '@kit.BasicServicesKit';
import { CameraState } from './CameraState';
import { AutoFocusFeature } from './features/autofocus/AutoFocusFeature';
import fileIO from '@ohos.fileio';
import { DeviceOrientationManager } from './features/sensororientation/DeviceOrientationManager';
import { Point } from './features/Point';
import { FlashFeature } from './features/flash/FlashFeature';
import { ExposureLockFeature } from './features/exposurelock/ExposureLockFeature';
import { ExposurePointFeature } from './features/exposurepoint/ExposurePointFeature';
import { ExposureOffsetFeature } from './features/exposureoffset/ExposureOffsetFeature';
import { FocusPointFeature } from './features/focuspoint/FocusPointFeature';
import { ZoomLevelFeature } from './features/zoomlevel/ZoomLevelFeature';
import { EventSink, StreamHandler } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import { FocusMode } from './features/autofocus/FocusMode';
import { ExposureMode } from './features/exposurelock/ExposureMode';
import PhotoAccessHelper from '@ohos.file.photoAccessHelper';
import systemDateTime from '@ohos.systemDateTime';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { picker } from '@kit.CoreFileKit';
import { DeviceOrientation } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/systemchannels/PlatformChannel';

const TAG = "Camera";

const FOUR = 4; // format
const EIGHT = 8; // capacity
const FOUR_THOUSAND_AND_SIXTY_NINE = 4096; // buffer大小

const supportedImageFormats: HashMap<string, image.ImageFormat> = new HashMap();
supportedImageFormats.set("ycbr422sp", image.ImageFormat.YCBCR_422_SP);
supportedImageFormats.set("jpeg", image.ImageFormat.JPEG);

export class Camera implements CameraCaptureStateListener {
  private static TAG: string = 'Camera';
  cameraFeatures: CameraFeatures;
  private imageFormatGroup: string | null = null;
  private videoRenderer: VideoRenderer | null = null;
  private flutterTexture: SurfaceTextureEntry;
  private resolutionPreset: ResolutionPreset;
  private enableAudio: boolean;
  private applicationContext: Context;
  dartMessenger: DartMessenger;
  private cameraProperties: CameraProperties;
  private cameraFeatureFactory: CameraFeatureFactory;
  private ability: Ability;
  private cameraCaptureCallback: CameraCaptureCallback;
  private cameraDevice: camera.CameraDevice | null = null;
  private cameraInput: camera.CameraInput | null = null;
  private imageReceiver: image.ImageReceiver | null = null;
  imageStreamReader: ImageStreamReader | null = null;
  private previewOutput: camera.PreviewOutput | null = null;
  private pausedPreview: boolean = false; // 暂停预览
  private captureTimeouts: CaptureTimeoutsWrapper;
  private captureProps: CameraCaptureProperties;
  private cameraManager: camera.CameraManager;
  private avRecorder: media.AVRecorder | null = null;
  private videoOutput: camera.VideoOutput | null = null;
  private recordingVideo: boolean = false;
  private captureFile: fs.File | null = null;
  private cameraOutputCapability: camera.CameraOutputCapability | null = null;
  private initialCameraFacing: number = 0;
  private photoSession: camera.PhotoSession | null = null; // 拍照模式
  private videoSession: camera.VideoSession | null = null; // 视频模式
  private cameras: Array<camera.CameraDevice> | null = null;
  private photoOutPut: camera.PhotoOutput | null = null;
  private fd: number = -1;
  private isVideoMode: boolean = false; // 视频模式
  private aVRecorderProfile: media.AVRecorderProfile = {
    audioChannels: 2,
    audioCodec: media.CodecMimeType.AUDIO_AAC,
    audioBitrate: 48000,
    audioSampleRate: 48000,
    fileFormat: media.ContainerFormatType.CFT_MPEG_4, // 视频文件封装格式，只支持MP4
    videoBitrate: 100000000, // 视频比特率
    videoCodec: media.CodecMimeType.VIDEO_AVC, // 视频文件编码格式，支持mpeg4和avc两种格式
    videoFrameWidth: 1920, // 视频分辨率的宽
    videoFrameHeight: 1080, // 视频分辨率的高
    videoFrameRate: 30 // 视频帧率
  };
  private phAccessHelper: photoAccessHelper.PhotoAccessHelper;
  private videoPath: string | undefined = undefined;
  private videoId: string | undefined = undefined;

  constructor(
    ability: UIAbility,
    flutterTexture: SurfaceTextureEntry,
    cameraFeatureFactory: CameraFeatureFactory,
    dartMessenger: DartMessenger,
    cameraProperties: CameraProperties,
    resolutionPreset: ResolutionPreset,
    enableAudio: boolean
  ) {
    if (ability == null) {
      throw new Error('No Ability available!');
    }

    this.ability = ability;
    this.enableAudio = enableAudio;
    this.flutterTexture = flutterTexture;
    this.dartMessenger = dartMessenger;
    this.applicationContext = ability.context;
    this.cameraProperties = cameraProperties;
    this.cameraFeatureFactory = cameraFeatureFactory;
    this.resolutionPreset = resolutionPreset;
    this.cameraFeatures =
      CameraFeatures.init(
        cameraFeatureFactory, cameraProperties, ability, dartMessenger, resolutionPreset);

    this.cameraManager = CameraUtils.getCameraManager(this.applicationContext);
    // Create capture callback.
    this.captureTimeouts = new CaptureTimeoutsWrapper(3000, 3000);
    this.captureProps = new CameraCaptureProperties();
    this.cameraCaptureCallback = CameraCaptureCallback.create(this, this.captureTimeouts, this.captureProps);

    this.phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
  }


  public onConverged(): void {
  }

  public onPrecapture(): void {
  }

  // 获取当前场景（拍照模式、视频模式）的Session实例
  getCurSession(): camera.PhotoSession | camera.VideoSession {
    return this.isVideoMode ? this.videoSession! : this.photoSession!;
  }

  public async open(imageFormatGroup: string | null): Promise<void> {
    this.imageFormatGroup = imageFormatGroup;
    const resolutionFeature: ResolutionFeature = this.cameraFeatures.getResolution();

    if (!resolutionFeature.checkIsSupported()) {
      this.dartMessenger.sendCameraErrorEvent(
        "Camera with name \""
          + this.cameraProperties.getCameraName()
          + "\" is not supported by this plugin.");
      return;
    }

    this.imageReceiver = image.createImageReceiver(
      resolutionFeature.getCaptureSize(),
      image.ImageFormat.JPEG,
      1);

    let imageFormat: number = supportedImageFormats.get(imageFormatGroup);
    if (imageFormat == null) {
      Log.w(TAG, "The selected imageFormatGroup is not supported by ohos. Defaulting to yuv420")
      imageFormat = image.ImageFormat.JPEG
    }

    this.imageStreamReader = new ImageStreamReader(
      resolutionFeature.getPreviewSize(),
      imageFormat,
      1
    )

    this.cameraDevice = CameraUtils.getCameraDevice(this.cameraProperties.getCameraName(), this.cameraManager);
    this.cameraInput = this.cameraManager.createCameraInput(this.cameraDevice);
    this.cameraInput.open()
      .then(() => {
        try {
          this.startPreview();
          if (!this.recordingVideo) {
            this.dartMessenger.sendCameraInitializedEvent(
              resolutionFeature.getPreviewSize().width,
              resolutionFeature.getPreviewSize().height,
              ExposureMode.getValueForMode(this.cameraFeatures.getExposureLock().getValue()),
              FocusMode.getValueForMode(this.cameraFeatures.getAutoFocus().getValue()),
              this.cameraFeatures.getExposurePoint().checkIsSupported(),
              this.cameraFeatures.getFocusPoint().checkIsSupported()
            )
          }
        } catch (e) {
          this.dartMessenger.sendCameraErrorEvent(e.message);
          this.close();
        }
      }).catch((err: BusinessError) => {
      this.close();
      let errorDescription: string;
      switch (err.code) {
        case camera.CameraErrorCode.INVALID_ARGUMENT:
          errorDescription = "Can not use camera cause of conflict.";
          break;
        case camera.CameraErrorCode.DEVICE_DISABLED:
          errorDescription = "Camera disabled cause of security reason.";
          break;
        case camera.CameraErrorCode.SERVICE_FATAL_ERROR:
          errorDescription = "Camera service fatal error.";
          break;
        default:
          errorDescription = "Unknown camera error";
      }
      this.dartMessenger.sendCameraErrorEvent(errorDescription);
    });
  }

  getDeviceOrientationManager(): DeviceOrientationManager {
    return this.cameraFeatures?.getSensorOrientation().getDeviceOrientationManager();
  }

  setFocusPoint(result: MethodResult, point: Point) {
    const focusPointFeature: FocusPointFeature = this.cameraFeatures.getFocusPoint();
    focusPointFeature.setValue(point);

    const focusPoint: camera.Point | null
      = (point.x == null || point.y == null) ? null : { x: point.x, y: point.y };
    try {
      this.getCurSession().setFocusPoint(focusPoint);
      result.success(null);
    } catch (error) {
      result.error("setFocusPointFailed", "Could not set focus point.", null);
    }
  }

  getFocusMode(result: MethodResult) {
    let nowFocusMode: camera.FocusMode = camera.FocusMode.FOCUS_MODE_AUTO

    try {
      // 获取当前对焦模式
      nowFocusMode = this.getCurSession().getFocusMode();
      if (nowFocusMode == camera.FocusMode.FOCUS_MODE_MANUAL) {
        nowFocusMode = camera.FocusMode.FOCUS_MODE_AUTO
      } else if (nowFocusMode == camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO) {
        nowFocusMode = camera.FocusMode.FOCUS_MODE_AUTO
      }
    } catch (error) {
      result?.error("getFocusModeFailed", "Could not get focus point", null)
    }

    this.setFocusMode(result, nowFocusMode);
  }

  setFocusMode(result: MethodResult, newMode: camera.FocusMode) {
    const autoFocusFeature: AutoFocusFeature = this.cameraFeatures.getAutoFocus();
    autoFocusFeature.setValue(newMode);

    try {
      this.getCurSession().setFocusMode(newMode)
      result?.success(null)
    } catch (error) {
      result?.success(null)
    }
  }

  // 设置曝光补偿
  setExposureOffset(result: MethodResult, offset: number) {
    const exposureOffsetFeature: ExposureOffsetFeature = this.cameraFeatures.getExposureOffset();
    exposureOffsetFeature.setValue(offset, this.photoSession!);

    try {
      this.getCurSession().setExposureBias(offset);
      result.success(exposureOffsetFeature.getValue());
    } catch (error) {
      result.error("setExposureOffsetFailed", "Could not set exposure offset.", null);
    }
  }

  public getMaxZoomLevel(): number {
    return this.cameraFeatures.getZoomLevel().getMaximumZoomLevel(this.getCurSession());
  }

  public getMinZoomLevel(): number {
    return this.cameraFeatures.getZoomLevel().getMinimumZoomLevel(this.getCurSession());
  }

  public setZoomLevel(result: MethodResult, zoom: number): void {
    const zoomLevel: ZoomLevelFeature = this.cameraFeatures.getZoomLevel();
    let maxZoom: number = zoomLevel.getMaximumZoomLevel(this.getCurSession());
    let minZoom: number = zoomLevel.getMinimumZoomLevel(this.getCurSession());

    if (zoom > maxZoom || zoom < minZoom) {
      result.error("ZOOM_ERROR",
        "Zoom level out of bounds (zoom level should be between " + minZoom + " and " + maxZoom + ").", null);
      return;
    }

    zoomLevel.setValue(zoom);
    try {
      this.getCurSession().setZoomRatio(zoom);
    } catch (error) {
      result.error("setZoomLevelFailed", "Could not set exposure point.", null);
    }
  }

  public lockCaptureOrientation(orientation: DeviceOrientation): void {
    this.cameraFeatures.getSensorOrientation().lockCaptureOrientation(orientation);
  }

  public unlockCaptureOrientation(): void {
    this.cameraFeatures.getSensorOrientation().unlockCaptureOrientation();
  }

  // 暂停预览
  public async pausePreview(result: MethodResult) {
    try {
      await this.previewOutput?.stop();
    } catch (e) {
    }
    this.pausedPreview = true;
    result.success(null);
  }

  // 恢复预览
  public async resumePreview(result: MethodResult) {
    try {
      if (this.pausedPreview) {
        await this.previewOutput?.start();
      }
    } catch (e) {
    }
    this.pausedPreview = false;
    result.success(null);
  }

  // 设置曝光区域中心点
  setExposurePoint(result: MethodResult, point: Point) {
    const exposurePointFeature: ExposurePointFeature = this.cameraFeatures.getExposurePoint();
    exposurePointFeature.setValue(point);

    const exposurePoint: camera.Point | null
      = (point.x == null || point.y == null) ? null : { x: point.x, y: point.y };

    try {
      this.getCurSession().setMeteringPoint(exposurePoint);
      result.success(null);
    } catch (error) {
      result.error("setExposurePointFailed", "Could not set exposure point.", null);
    }
  }

  // 设置曝光模式。
  // 进行设置之前，需要先检查设备是否支持指定的曝光模式，可使用方法isExposureModeSupported。
  setExposureMode(result: MethodResult, newMode: camera.ExposureMode) {
    // if (CameraUtils.isExposureModeSupported(this.photoSession!, newMode)) {
    //   result.error("setExposureModeFailed", "The exposure mode is unsupported.", null);
    //   return;
    // }

    let modeExistence: boolean = false;
    Object.values(camera.ExposureMode).forEach(async (value) => {
      if (newMode == value) {
        modeExistence = true
      }
    })

    if (!modeExistence) {
      result.error("setExposureModeFailed", "The exposure mode is unsupported.", null);
      return;
    }

    const exposureLockFeature: ExposureLockFeature = this.cameraFeatures.getExposureLock();
    exposureLockFeature.setValue(newMode);

    try {
      this.getCurSession().setExposureMode(newMode);
      result.success(null)
    } catch (error) {
      result.success(null)
    }
  }

  // 设置闪光灯模式。
  // 进行设置之前，需要先检查：
  // 设备是否支持闪光灯，可使用方法hasFlash。
  // 设备是否支持指定的闪光灯模式，可使用方法isFlashModeSupported。
  setFlashMode(result: MethodResult, newMode: camera.FlashMode) {
    if (!CameraUtils.hasFlash(this.getCurSession())) {
      result.error("setFlashModeFailed", "The camera device does not have flash.", null);
      return;
    }

    if (!CameraUtils.isFlashModeSupported(this.getCurSession(), newMode)) {
      result.error("setFlashModeFailed", " The flash mode is unsupported.", null);
      return;
    }

    // Save the new flash mode setting.
    const flashFeature: FlashFeature = this.cameraFeatures.getFlash();
    flashFeature.setValue(newMode);

    try {
      this.getCurSession().setFlashMode(newMode);
      result.success(null);
    } catch (error) {
      result.error("setFlashModeFailed", "The setFlashMode call failed", null);
    }
  }

  getMinExposureOffset() {
    return this.cameraFeatures.getExposureOffset().getMinExposureOffset(this.getCurSession());
  }

  getMaxExposureOffset() {
    return this.cameraFeatures.getExposureOffset().getMaxExposureOffset(this.getCurSession());
  }

  getExposureOffsetStepSize() {
    return this.cameraFeatures.getExposureOffset().getExposureOffsetStepSize(this.getCurSession());
  }

  async takePicture(result: MethodResult) {
    if (this.cameraCaptureCallback.getCameraState() != CameraState.STATE_PREVIEW) {
      result.error("captureAlreadyActive", "Picture is currently already being captured", null);
      return;
    }

    //接收图片时注册回调
    this.imageReceiver?.on('imageArrival', () => {
      this.imageReceiver?.readNextImage((err, _image) => {
        if (err || _image === undefined) {
          return;
        }
        _image.getComponent(image.ComponentType.JPEG, (errMsg, img) => {
          if (errMsg || img === undefined) {
            return;
          }
          let buffer: ArrayBuffer;
          if (img.byteBuffer) {
            buffer = img.byteBuffer;
          } else {
            console.error(TAG, 'img.byteBuffer is undefined');
            this.dartMessenger.sendCameraErrorEvent('img.byteBuffer is undefined');
            return;
          }
          this.savePicture(buffer, _image).then((path: string) => {
            result.success(path);
          });
        })
      });
    })
    this.runPictureAutoFocus();
  }

  async savePicture(buffer: ArrayBuffer, img: image.Image) {
    let photoUri: string = getContext(this).cacheDir + '/IMG_' + Date.now().toString() + '.jpg';
    let file: fs.File = fs.openSync(photoUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    await fs.write(file.fd, buffer);
    fs.closeSync(file);
    img.release();
    return photoUri;
  }

  /** Start capturing a picture, doing autofocus first. */
  private runPictureAutoFocus() {
    this.cameraCaptureCallback.setCameraState(CameraState.STATE_WAITING_FOCUS);
    this.lockAutoFocus();
  }

  async lockAutoFocus(): Promise<void> {
    if (this.photoSession == null) {
      console.error(TAG, "[unlockAutoFocus] captureSession null, returning");
      return;
    }

    let captureLocation: camera.Location = {
      latitude: 0,
      longitude: 0,
      altitude: 0,
    };
    let settings: camera.PhotoCaptureSetting = {
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,
      rotation: camera.ImageRotation.ROTATION_0,
      location: captureLocation,
      mirror: false,
    };

    this.cameraCaptureCallback.setCameraState(CameraState.STATE_CAPTURING);

    // 触发拍照
    this.photoOutPut?.capture(settings, (err: BusinessError) => {
      // 拍照完成，更新CameraState
      this.cameraCaptureCallback.setCameraState(CameraState.STATE_PREVIEW);
      if (err) {
        console.error(`Failed to capture the photo ${err.code}`);
        this.dartMessenger.sendCameraErrorEvent(err.message);
        return;
      }
      // 拍照成功
    });
  }

  unlockAutoFocus(): void {
    if (this.photoSession == null) {
      console.info("[unlockAutoFocus] captureSession null, returning");
      return;
    }
    try {

    } catch (e) {
      this.dartMessenger.sendCameraErrorEvent(e.message)
      return;
    }
  }

  startVideoRecording(result: MethodResult, imageStreamChannel: EventChannel) {
    this.prepareRecording(result);

    if (imageStreamChannel != null) {
      this.setStreamHandler(imageStreamChannel);
    }

    this.initialCameraFacing = this.cameraProperties.getLensFacing();
    this.recordingVideo = true;

    try {
      // 开始录制
      this.startCapture(true, imageStreamChannel != null);
      result.success(null);
    } catch (e) {
      this.recordingVideo = false;
      this.captureFile = null;
      result.error("videoRecordingFailed", e.getMessage(), null);
    }
  }

  async stopVideoRecording(result: MethodResult) {

    if (!this.recordingVideo) {
      result.success(null);
      return;
    }

    this.cameraFeatures.setAutoFocus(this.cameraFeatureFactory.createAutoFocusFeature(this.cameraProperties, false));
    try {
      // 仅在started和paused状态下调用stop为合理状态切换
      if (this.avRecorder != undefined && (this.avRecorder.state === 'started' || this.avRecorder.state === 'paused')) {
        // 停止录像
        await this.avRecorder?.stop();
        this.avRecorder?.release().then(() => {
          this.recordingVideo = false;
          // 停止录像输出流
          this.videoOutput?.stop();
          this.videoPath = this.captureFile?.path;
          fs.close(this.captureFile);
          result.success(this.videoPath);
          this.captureFile = null;
          this.isVideoMode = false;
          this.open(this.imageFormatGroup);
        });
      }
    } catch (e) {
      Log.d(TAG, "videoSession stop error")
    }

  }

  startPreview() {
    if (this.recordingVideo) {
      this.startPreviewWithVideo();
    } else {
      this.startPreviewWithPhoto();
    }
  }

  // 开启录像预览
  async startPreviewWithVideo() {
    this.cameraOutputCapability =
      CameraUtils.getSupportedOutputCapability(this.cameraDevice!, camera.SceneMode.NORMAL_VIDEO,
        this.cameraManager);
    let previewProfile = this.cameraOutputCapability?.previewProfiles[0];
    this.previewOutput = this.cameraManager.createPreviewOutput(previewProfile, this.flutterTexture.getSurfaceId()
      .toString());
    let videoProfilesArray: Array<camera.VideoProfile> = this.cameraOutputCapability?.videoProfiles;
    let videoProfile: undefined | camera.VideoProfile = videoProfilesArray.find((profile: camera.VideoProfile) => {
      return profile.size.width === this.aVRecorderProfile.videoFrameWidth &&
        profile.size.height === this.aVRecorderProfile.videoFrameHeight;
    })
    this.videoOutput = this.cameraManager.createVideoOutput(videoProfile, this.videoId);
    this.videoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO) as camera.VideoSession;
    this.videoSession?.beginConfig();
    this.videoSession?.addInput(this.cameraInput);
    this.videoSession?.addOutput(this.previewOutput);
    this.videoSession?.addOutput(this.videoOutput);
    await this.videoSession?.commitConfig();
    await this.videoSession?.start();
    if (this.pausedPreview) {
      this.previewOutput.stop();
    }
    if (this.recordingVideo && this.avRecorder != undefined && this.avRecorder.state === 'paused') {
      // 录像中且暂停状态
    } else {
      await this.videoOutput.start();
    }
  }

  // 开启拍照预览
  async startPreviewWithPhoto() {
    this.cameraOutputCapability =
      CameraUtils.getSupportedOutputCapability(this.cameraDevice!, camera.SceneMode.NORMAL_PHOTO, this.cameraManager)
    let captureSize: camera.Size = this.cameraFeatures.getResolution().getCaptureSize();

    let previewProfile = this.cameraOutputCapability.previewProfiles.find((profile: camera.Profile) => {
      return profile.size.width === captureSize.width && profile.size.height === captureSize.height;
    });
    this.previewOutput =
      this.cameraManager.createPreviewOutput(previewProfile, this.flutterTexture.getSurfaceId().toString());
    let photoProfile = this.cameraOutputCapability.photoProfiles.find((profile: camera.Profile) => {
      return profile.size.width === captureSize.width && profile.size.height === captureSize.height;
    });
    let rSurfaceId = await this.imageReceiver!.getReceivingSurfaceId();
    this.photoOutPut = this.cameraManager.createPhotoOutput(photoProfile, rSurfaceId);

    this.photoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO) as camera.PhotoSession;
    this.photoSession.beginConfig();
    this.photoSession.addInput(this.cameraInput);
    this.photoSession.addOutput(this.previewOutput);
    this.photoSession.addOutput(this.photoOutPut);
    await this.photoSession.commitConfig();
    await this.photoSession.start();
    if (this.pausedPreview) {
      await this.previewOutput.stop();
    }
  }

  async pauseVideoRecording(result: MethodResult) {
    if (!this.recordingVideo) {
      result.success(null);
      return;
    }

    try {
      if (this.avRecorder != undefined && this.avRecorder.state === 'started') { // 仅在started状态下调用pause为合理状态切换
        await this.avRecorder.pause();
        await this.videoOutput?.stop(); // 停止相机出流
      }

    } catch (e) {
      Log.d(TAG, "pauseVideoRecording error")
      result.error("videoRecordingFailed", e.getMessage(), null);
      return;
    }
    result.success(null);
  }

  async resumeVideoRecording(result: MethodResult) {
    if (!this.recordingVideo) {
      result.success(null);
      return;
    }
    try {
      if (this.avRecorder != undefined && this.avRecorder.state === 'paused') { // 仅在paused状态下调用resume为合理状态切换
        await this.videoOutput?.start(); // 启动相机出流
        await this.avRecorder?.resume();
      } else {
        result.error(
          "videoRecordingFailed", "avRecorder state is not paused", null);
        return;
      }
    } catch (e) {
      result.error("videoRecordingFailed", e.getMessage(), null);
      return;
    }

    result.success(null);
  }

  startPreviewWithImageStream(imageStreamChannel: EventChannel) {
    this.setStreamHandler(imageStreamChannel);
    this.startImageStream();
  }

  async startImageStream() {
    try {
      if (this.photoSession != null) {
        await this.photoSession?.stop()
      }
    } catch (e) {
    }
    try {
      if (this.videoSession != null) {
        await this.videoSession?.stop();
      }
    } catch (e) {
    }

    let profiles =
      CameraUtils.getSupportedOutputCapability(this.cameraDevice!, camera.SceneMode.NORMAL_PHOTO, this.cameraManager)
    let previewProfiles: Array<camera.Profile> = profiles.previewProfiles;
    let captureSize: camera.Size = this.cameraFeatures.getResolution().getCaptureSize();
    let previewProfilesObj = previewProfiles.find((profile: camera.Profile) => {
      return profile.size.width === captureSize.width && profile.size.height === captureSize.height;
    });
    let previewProfilesObj2 = previewProfiles.find((profile: camera.Profile) => {
      return profile.size.width === captureSize.width && profile.size.height === captureSize.height;
    });

    this.previewOutput =
      this.cameraManager.createPreviewOutput(previewProfilesObj, this.flutterTexture.getSurfaceId().toString());
    let imageReceiverSurfaceId: string = await this.imageStreamReader!.getReceivingSurfaceId();
    let previewOutput2: camera.PreviewOutput =
      this.cameraManager.createPreviewOutput(previewProfilesObj2, imageReceiverSurfaceId);

    this.photoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO) as camera.PhotoSession;
    this.photoSession.beginConfig();
    await this.cameraInput?.open();
    this.photoSession.addInput(this.cameraInput);
    this.photoSession.addOutput(this.previewOutput);
    this.photoSession.addOutput(previewOutput2);
    await this.photoSession.commitConfig();
    await this.photoSession.start();
  }

  async prepareMediaRecorder(cameraManager: camera.CameraManager,
    cameraOutputCapability: camera.CameraOutputCapability, url: string) {
    Log.i(TAG, "prepareMediaRecorder");
    if (this.avRecorder != null) {
      this.avRecorder.release();
    }
  }

  async startCapture(record: boolean, stream: boolean) {
    if (!this.pausedPreview) {
      this.getCurSession().stop();
    }
    this.photoSession = null;
    this.isVideoMode = true;
    media.createAVRecorder(async (error, recorder) => {
      if (recorder != null) {
        this.avRecorder = recorder;
        let videoUri: string = getContext(this).cacheDir + '/REC' + Date.now().toString() + '.mp4';
        this.captureFile = fs.openSync(videoUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        let fd = this.captureFile.fd;
        // 当前录像配置
        let aVRecorderConfig: media.AVRecorderConfig = {
          audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
          videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
          profile: this.aVRecorderProfile,
          url: `fd://${fd}`,
          rotation: 90, // 90°为默认竖屏显示角度，如果由于设备原因或应用期望以其他方式显示等原因，请根据实际情况调整该参数
        };
        await this.avRecorder.prepare(aVRecorderConfig).then(async () => {
          this.videoId = await this.avRecorder?.getInputSurface();
        });
        this.cameraOutputCapability =
          CameraUtils.getSupportedOutputCapability(this.cameraDevice!, camera.SceneMode.NORMAL_VIDEO,
            this.cameraManager);
        let previewProfile = this.cameraOutputCapability?.previewProfiles[0];
        this.previewOutput = this.cameraManager.createPreviewOutput(previewProfile, this.flutterTexture.getSurfaceId()
          .toString());
        let videoProfilesArray: Array<camera.VideoProfile> = this.cameraOutputCapability?.videoProfiles;
        let videoProfile: undefined | camera.VideoProfile = videoProfilesArray.find((profile: camera.VideoProfile) => {
          return profile.size.width === this.aVRecorderProfile.videoFrameWidth &&
            profile.size.height === this.aVRecorderProfile.videoFrameHeight;
        })
        this.videoOutput = this.cameraManager.createVideoOutput(videoProfile, this.videoId);
        this.videoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO) as camera.VideoSession;
        this.videoSession?.beginConfig();
        await this.cameraInput?.open();
        this.videoSession?.addInput(this.cameraInput);
        this.videoSession?.addOutput(this.previewOutput);
        this.videoSession?.addOutput(this.videoOutput);
        await this.videoSession?.commitConfig();
        await this.videoSession?.start();
        await this.videoOutput.start();
        try {
          if (this.pausedPreview) {
            await this.previewOutput.stop();
          }
          if (record) {
            await this.avRecorder.start();
          }
        } catch (e) {
          Log.d(TAG, "startAVRecorder error")
        }
      } else {
        Log.e(TAG, "startVideo createAVRecorder fail :" + error.message);
      }
    });
  }

  async prepareRecording(result: MethodResult): Promise<void> {
    this.cameraFeatures.setAutoFocus(this.cameraFeatureFactory.createAutoFocusFeature(this.cameraProperties, true));
  }

  private setStreamHandler(imageStreamChannel: EventChannel): void {
    let that = this;
    let streamHandler: StreamHandler = {
      onListen(args: ESObject, imageStreamSink: EventSink): void {
        that.setImageStreamImageAvailableListener(imageStreamSink);
      },
      onCancel(args: ESObject): void {
        if (that.imageStreamReader == null) {
          return
        }
        that.imageStreamReader.removeListener()
      }
    }
    imageStreamChannel.setStreamHandler(streamHandler)
  }

  private setImageStreamImageAvailableListener(imageStreamSink: EventSink) {
    if (this.imageStreamReader == null) {
      return;
    }
    this.imageStreamReader.subscribeListener(this.captureProps, imageStreamSink);
  }

  // 关闭
  public close(): void {
    this.stopAndReleaseCamera();
    this.imageReceiver?.release();
    this.imageReceiver = null;

    this.avRecorder?.reset();
    this.avRecorder?.release();
    this.avRecorder = null;

    this.cameraDevice = null;
    this.releaseSession();
    this.dartMessenger.sendCameraClosingEvent();
  }

  // 关闭摄像头输入流
  private stopAndReleaseCamera() {
    if (this.cameraInput != null) {
      try {
        this.photoSession?.removeInput(this.cameraInput);
      } catch (e) {
      }
      try {
        this.videoSession?.removeInput(this.cameraInput);
      } catch (e) {
      }

      this.cameraInput.close();
      this.cameraInput = null;
    }

    if (this.cameraDevice != null) {
      this.cameraDevice = null;
      this.photoSession = null;
      this.videoSession = null;
    } else {
      this.stopSession();
    }
  }

  // 停止Session
  async stopSession() {

    if (this.photoSession != null) {
      await this.photoSession.stop();
      this.photoSession = null;
    }
    if (this.videoSession != null) {
      await this.videoSession.stop();
      this.videoSession = null;
    }
  }

  public setDescriptionWhileRecording(result: MethodResult, properties: CameraProperties) {
    if (!this.recordingVideo) {
      result.error("setDescriptionWhileRecordingFailed", "Device was not recording", null);
      return;
    }

    this.stopAndReleaseCamera();

    this.cameraProperties = properties;
    this.cameraFeatures =
      CameraFeatures.init(
        this.cameraFeatureFactory, this.cameraProperties, this.ability, this.dartMessenger, this.resolutionPreset);
    this.cameraFeatures.setAutoFocus(
      this.cameraFeatureFactory.createAutoFocusFeature(this.cameraProperties, true));

    try {
      this.open(this.imageFormatGroup);
    } catch (e) {
      result.error("setDescriptionWhileRecordingFailed", e.getMessage(), null);
    }
    result.success(null);
  }

  dispose() {
    console.error(TAG, 'dispose');
    this.close();
    this.flutterTexture.release();
    this.getDeviceOrientationManager().stop();
  }

  // 释放Session
  private async releaseSession() {
    if (this.photoSession != null) {
      await this.photoSession.stop();
      await this.photoSession.release();
      this.photoSession = null;
    }
    if (this.videoSession != null) {
      await this.videoSession.stop();
      await this.videoSession.release();
      this.videoSession = null;
    }
  }

  private async releaseCameraInput() {
    if (this.cameraInput != null) {
      try {
        await this.cameraInput.close();
        this.cameraInput = null;
      } catch (e) {
      }
    }
  }

  private async releasePreviewOutput() {
    if (this.previewOutput != null) {
      try {
        await this.previewOutput.release();
        this.previewOutput = null;
      } catch (e) {
      }
    }
  }

  private async releasePhotoOutput() {
    if (this.photoOutPut != null) {
      try {
        await this.photoOutPut.release();
        this.photoOutPut = null;
      } catch (e) {
      }
    }
  }

  private async releaseVideoOutput() {
    if (this.videoOutput != null) {
      try {
        await this.videoOutput.stop();
        await this.videoOutput.release();
        this.videoOutput = null;
      } catch (e) {
      }
    }
  }

  // 释放Camera
  async releaseCamera() {
    await this.releaseCameraInput();
    await this.releaseSession();
    await this.releasePreviewOutput();
    await this.releaseVideoOutput();
    await this.releasePhotoOutput();
  }
}