/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import ArrayList from '@ohos.util.ArrayList';
import Want from '@ohos.app.ability.Want';
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import fs from '@ohos.file.fs'
import common from '@ohos.app.ability.common';
import wantConstant from '@ohos.ability.wantConstant';
import bundleManager from '@ohos.bundle.bundleManager';
import ImagePickerCache, { CacheType } from './ImagePickerCache'
import FileUtils from './FileUtils'
import StartOptions from '@ohos.app.ability.StartOptions';
import {
  FlutterError,
  ImageSelectionOptions,
  VideoSelectionOptions,
  Result,
  CacheRetrievalResult,
  CacheRetrievalResultBuilder,
  MediaSelectionOptions,
  GeneralOptions
} from './Messages'
import ImageResizer from './ImageResizer';
import HashMap from '@ohos.util.HashMap';
import UIAbility from '@ohos.app.ability.UIAbility';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';

export default class ImagePickerDelegate {
  readonly REQUEST_CODE_CHOOSE_IMAGE_FROM_GALLERY = 2342;
  readonly REQUEST_CODE_TAKE_IMAGE_WITH_CAMERA = 2343;
  readonly REQUEST_CAMERA_IMAGE_PERMISSION = 2345;
  readonly REQUEST_CODE_CHOOSE_MULTI_IMAGE_FROM_GALLERY = 2346;
  readonly REQUEST_CODE_CHOOSE_MEDIA_FROM_GALLERY = 2347;
  readonly REQUEST_CODE_CHOOSE_VIDEO_FROM_GALLERY = 2352;
  readonly REQUEST_CODE_TAKE_VIDEO_WITH_CAMERA = 2353;
  readonly REQUEST_CAMERA_VIDEO_PERMISSION = 2355;
  private static TAG = "ImagePickerDelegate";
  private imageResizer: ImageResizer;
  private cache: ImagePickerCache;
  private pendingCameraMediaUri: string | null = null;
  private pendingCallState: PendingCallState | null = null;
  private context: common.UIAbilityContext | null = null;

  constructor(ability: UIAbility, imageResizer: ImageResizer, cache: ImagePickerCache, context?: common.UIAbilityContext,
              pendingImageOptions?: ImageSelectionOptions, pendingVideoOptions?: VideoSelectionOptions,
              result?: Result<ArrayList<string>>, fileUtils?: FileUtils) {
    this.imageResizer = imageResizer;
    if (result != null) {
      this.pendingCallState = new PendingCallState(pendingImageOptions as ESObject, pendingVideoOptions, result);
    }
    this.cache = cache;
    this.context = ability.context;
  }

  /* 当前默认调用仅支持后置摄像头 */
  setCameraDevice(device: CameraDevice): void {
  }

  saveStateBeforeResult(): void {
    let localImageOptions: ImageSelectionOptions;

    if (this.pendingCallState == null) {
      return;
    }
    localImageOptions = this.pendingCallState.imageOptions;

    this.cache.saveType(localImageOptions != null ? CacheType.IMAGE : CacheType.VIDEO);
    if (localImageOptions != null) {
      this.cache.saveDimensionWithOutputOptions(localImageOptions);
    }

    let localPendingCameraMediaUri = this.pendingCameraMediaUri;
    if (localPendingCameraMediaUri != null) {
      this.cache.savePendingCameraMediaUriPath(localPendingCameraMediaUri);
    }
  }

  async retrieveLostImage(): Promise<CacheRetrievalResult | null> {
    // let cacheMap: HashMap<string, ESObject|null> = await this.cache.getCacheMap().then(map=> {
    //   return map;
    // });
    let cacheMap: HashMap<string, ESObject | null> = await this.cache.getCacheMap()
    if (cacheMap.isEmpty()) {
      return null;
    }
    let result = new CacheRetrievalResultBuilder(null, null, null, null);
    let type: ESObject = cacheMap.get(ImagePickerCache.MAP_KEY_TYPE);
    if (type != null && result.setType) {
      result.setType(type);
    }
    if (result.setError) {
      result.setError(cacheMap.get(ImagePickerCache.MAP_KEY_ERROR));
    }

    let pathList: ArrayList<string> = cacheMap.get(ImagePickerCache.MAP_KEY_PATH_LIST) as ArrayList<string>;
    if (pathList != null) {
      let newPathList: ArrayList<string> = new ArrayList();
      for (let path of pathList) {
        let maxWidth: number = cacheMap.get(ImagePickerCache.MAP_KEY_MAX_WIDTH) as number;
        let maxHeight: number = cacheMap.get(ImagePickerCache.MAP_KEY_MAX_HEIGHT) as number;
        let boxedImageQuality: number = cacheMap.get(ImagePickerCache.MAP_KEY_IMAGE_QUALITY) as number;
        let imageQulity: number = boxedImageQuality == null ? 100 : boxedImageQuality;

        newPathList.add(await this.imageResizer.resizeImageIfNeeded(path, maxWidth, maxHeight, imageQulity)
          .then((fileName) => {
            return fileName;
          })
        );
      }
      if (result.setPaths) {
        result.setPaths(newPathList);
      }

    }
    this.cache.clear();
    return result.build ? result.build() : null;
  }

  chooseMediaFromGallery(options: MediaSelectionOptions, generalOptions: GeneralOptions,
                         result: Result<ArrayList<string>>): void {
    if (!this.setPendingOptionsAndResult(options.getImageSelectionOptions(), null, result)) {
      this.finishWithAlreadyActiveError(result);
      return;
    }
    this.launchPickMediaFromGalleryWant(generalOptions);
  }

  launchPickMediaFromGalleryWant(generalOptions: GeneralOptions): void {
    let config: Want = {
      action: 'ohos.want.action.photoPicker',
      type: generalOptions.getAllowMultiple() ? 'multipleselect' : 'singleselect',
      parameters: {
        uri: generalOptions.getAllowMultiple() ? 'multipleselect' : 'singleselect',
        maxSelectCount: generalOptions.getAllowMultiple() ? 9 : 1,
        filterMediaType: 'FILTER_MEDIA_TYPE_ALL'
      }
    };
    let options: StartOptions = {
      displayId: 0,
    };
    if (!this.context) {
      return
    }
    this.context.startAbilityForResult(config, options).then(result => {
      if (result && result.want && result.want.parameters) {
        let uris: Array<string> = result.want.parameters['select-item-list'] as Array<string>;
        let code = result["resultCode"] as number;
        Log.i(ImagePickerDelegate.TAG, "startAbilityForResult : " + JSON.stringify(result.want.parameters));
        this.handleChooseMediaResult(code, uris);
      }

    });
  }

  handleChooseMediaResult(code: number, uris: Array<string>): void {
    if (code == 0) {
      this.handleMediaResultTwo(uris);
    } else {
      this.finishWithListSuccess(null);
    }
  }

  async handleMediaResultTwo(uris: Array<string>): Promise<void> {
    let localImageOptions: ImageSelectionOptions | null = null;
    if (this.pendingCallState != null) {
      localImageOptions = this.pendingCallState.imageOptions;
    }
    let pathList: ArrayList<string> = new ArrayList();
    if (localImageOptions != null && localImageOptions != undefined) {
      for (let path of uris) {
        if (path.search("video") < 0 && this.pendingCallState) {
          path = await this.getResizedImagePath(path, this.pendingCallState.imageOptions);
        }
        let realPath = FileUtils.getPathFromUri(this.context, path);
        Log.i(ImagePickerDelegate.TAG, "getPathFromUri : " + realPath);
        pathList.add(realPath);
      }
    } else {
      for (let path of uris) {
        let realPath = FileUtils.getPathFromUri(this.context, path);
        pathList.add(realPath);
      }
    }
    this.finishWithListSuccess(pathList);
  }

  chooseVideoFromGallery(options: VideoSelectionOptions, usePhotoPicker: boolean, result: Result<ArrayList<string>>): void {
    if (!this.setPendingOptionsAndResult(null, options, result)) {
      this.finishWithAlreadyActiveError(result);
      return;
    }

    this.launchPickVideoFromGalleryWant(usePhotoPicker);
  }

  async launchPickVideoFromGalleryWant(usePhotoPicker: boolean): Promise<void> {
    Log.i(ImagePickerDelegate.TAG, "launchPickVideoFromGalleryWant enter");
    let config: Want = {
      action: 'ohos.want.action.photoPicker',
      type: 'singleselect',
      parameters: {
        uri: 'singleselect',
        maxSelectCount: 1,
        filterMediaType: 'FILTER_MEDIA_TYPE_VIDEO'
      }
    };

    let options: StartOptions = {
      displayId: 0,
    };
    let result: ESObject = null
    if (this.context) {
      result = await this.context.startAbilityForResult(config, options);
    }

    if (result && result.want && result.want.parameters) {
      let uris = result.want.parameters['select-item-list'] as Array<string>;
      let code = result.resultCode as number;
      this.handleChooseVideoResult(code, uris);
    }

  }

  handleChooseVideoResult(code: number, uris: Array<string>): void {
    if (code == 0) {
      let realPath = FileUtils.getPathFromUri(this.context, uris[0]);
      this.handleVideoResult(realPath as string, false);
    } else {
      this.finishWithSuccess(null);
    }
  }

  takeVideoWithCamera(options: VideoSelectionOptions, result: Result<ArrayList<string>>): void {
    if (!this.setPendingOptionsAndResult(null, options, result)) {
      this.finishWithAlreadyActiveError(result);
      return;
    }

    Log.i(ImagePickerDelegate.TAG, "launchTakeVideoWithCameraWant duration: " + options.getMaxDurationSeconds());
    this.launchTakeVideoWithCameraWant(options.getMaxDurationSeconds());
  }

  async launchTakeVideoWithCameraWant(duration: number): Promise<void> {
    let want: Want = {
      "action": wantConstant.Action.ACTION_VIDEO_CAPTURE,
      parameters: {
        callBundleName: "flutter_embedding",
        "supportMultiMode": false,
        durationLimit: duration
      }
    }
    abilityAccessCtrl.createAtManager()
      .requestPermissionsFromUser(this.context, ['ohos.permission.READ_MEDIA'])
      .then(async (permission) => {
        if(permission.authResults[0] !== 0){
          return
        }
        let result: ESObject = null;
        if (this.context) {
          result = await this.context.startAbilityForResult(want);
        }
        if (result && result.want && result.want.parameters) {
          let uri = result["want"]["parameters"].resourceUri as string;
          let code = result["resultCode"] as number;
          this.handlerCaptureImageResult(code, uri);
        }

      });
  }

  async chooseImageFromGallery(options: ImageSelectionOptions, usePhotoPicker: boolean, result: Result<ArrayList<string>>): Promise<void> {
    Log.i(ImagePickerDelegate.TAG, "chooseImageFromGallery enter");
    if (!this.setPendingOptionsAndResult(options, null, result)) {
      this.finishWithAlreadyActiveError(result);
      return;
    }

    await this.launchPickImageFromGalleryWant(usePhotoPicker);
  }

  async launchPickImageFromGalleryWant(usePhotoPicker: boolean): Promise<void> {
    Log.i(ImagePickerDelegate.TAG, "launchPickImageFromGalleryWant enter");
    let config: Want = {
      action: 'ohos.want.action.photoPicker',
      type: 'singleselect',
      parameters: {
        uri: 'singleselect',
        maxSelectCount: 1,
        filterMediaType: 'FILTER_MEDIA_TYPE_IMAGE'
      }
    };

    let options: StartOptions = {
      displayId: 0,
    };
    let result: ESObject = null;
    if (this.context) {
      result = await this.context.startAbilityForResult(config, options);
    }
    if (result && result.want && result.want.parameters) {
      let uris = result?.want?.parameters['select-item-list'] as Array<string>;
      let code = result.resultCode as number;
      this.handleChooseImageResult(code, uris);
    }
  }

  handleChooseImageResult(code: number, uris: Array<string>): void {
    if (code == 0) {
      let realPath = FileUtils.getPathFromUri(this.context, uris[0]);
      this.handleImageResult(realPath as string, false);
    } else {
      this.finishWithSuccess(null);
    }
  }

  chooseMultiImagesFromGallery(options: ImageSelectionOptions, usePhotoPicker: boolean, result: Result<ArrayList<string>>): void {
    if (!this.setPendingOptionsAndResult(options, null, result)) {
      this.finishWithAlreadyActiveError(result);
      return;
    }

    this.launchMultiPickImageFromGalleryWant(usePhotoPicker);
  }

  async launchMultiPickImageFromGalleryWant(usePhotoPicker: boolean): Promise<void> {
    let config: Want = {
      action: 'ohos.want.action.photoPicker',
      type: 'multipleselect',
      parameters: {
        uri: 'multipleselect',
        maxSelectCount: 9,
        filterMediaType: 'FILTER_MEDIA_TYPE_IMAGE'
      }
    };

    let options: StartOptions = {
      displayId: 0,
    };
    let result: ESObject = null;
    if (this.context) {
      result = await this.context.startAbilityForResult(config, options);
    }
    if (result && result.want && result.want.parameters) {
      let uris = result?.want?.parameters['select-item-list'] as Array<string>;
      let resultCode = result.resultCode as number;
      this.handleChooseMediaResult(resultCode, uris);
    }

  }

  takeImageWithCamera(options: ImageSelectionOptions, result: Result<ArrayList<string>>): void {
    if (!this.setPendingOptionsAndResult(options, null, result)) {
      this.finishWithAlreadyActiveError(result);
      return;
    }
    this.launchTakeImageWithCameraWant();
  }

  async launchTakeImageWithCameraWant(): Promise<void> {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    let bundleName = ""
    try {
      let t = await bundleManager.getBundleInfoForSelf(bundleFlags)
      bundleName = t.name
    } catch (err) {
      let message = (err as BusinessError).message;
      Log.e('getBundleInfoForSelf failed: %{public}s', message);
    }

    let want: Want = {
      "action": wantConstant.Action.ACTION_IMAGE_CAPTURE,
      parameters: {
        callBundleName: bundleName || "flutter_embedding",
        "supportMultiMode": false
      }
    }
    let result: ESObject = null
    if (this.context) {
      result = await this.context.startAbilityForResult(want);
    }

    if (!result) {
      return
    }
    let uri = result["want"]["parameters"].resourceUri as string;
    let code = result["resultCode"] as number;
    this.pendingCameraMediaUri = uri;
    this.handlerCaptureImageResult(code, uri);
  }

  setPendingOptionsAndResult(imageOptions: ImageSelectionOptions | null, videoOptions: VideoSelectionOptions | null,
                             result: Result<ArrayList<string>>): boolean {
    if (this.pendingCallState != null && this.pendingCallState != undefined) {
      Log.i(ImagePickerDelegate.TAG, "There is already an open gallery, use it directly to select images");
    } else {
      Log.i(ImagePickerDelegate.TAG, "Prepare to awaken a new one");
      this.pendingCallState = new PendingCallState(imageOptions, videoOptions, result);
    }
    this.cache.clear();
    return true;
  }

  finishWithAlreadyActiveError(result: Result<ArrayList<string>>) {
    result.error(new FlutterError("already_active", "Image picker is already active", null));
  }

  handlerCaptureImageResult(code: number, path: string): void {
    if (code == 0 || code == -1) {
      Log.e(ImagePickerDelegate.TAG, "startAbilityForResult for taking image success");
      this.handleImageResult(path, true);
    } else {
      this.finishWithSuccess(null);
    }
  }

  handlerCaptureVideoResult(code: number, path: string): void {
    if (code == 0 || code == -1) {
      Log.e(ImagePickerDelegate.TAG, "startAbilityForResult for taking video success");
      this.handleVideoResult(path, false);
    }
    else {
      this.finishWithSuccess(null);
    }
  }

  async handleImageResult(path: string, shouldDeleteOriginalIfScaled: boolean): Promise<void> {
    Log.i(ImagePickerDelegate.TAG, 'handleImageResult enter');
    let localImageOptions: ImageSelectionOptions | null = null;
    if (this.pendingCallState != null) {
      localImageOptions = this.pendingCallState.imageOptions;
    }

    if (localImageOptions != null) {
      let finalImagePath = await this.getResizedImagePath(path, localImageOptions);
      if (finalImagePath != null && finalImagePath != path && shouldDeleteOriginalIfScaled) {
        fs.unlink(path);
      }
      this.finishWithSuccess(finalImagePath);
    } else {
      this.finishWithSuccess(path);
    }
  }

  async handleMediaResult(paths: Array<string>) {
    let localImageOptions: ImageSelectionOptions | null = null;
    if (this.pendingCallState != null) {
      localImageOptions = this.pendingCallState.imageOptions;
    }

    if (localImageOptions != null) {
      for (let i: number = 0; i < paths.length; i++) {
        let path = paths[i];
        Log.i("yjm 0801 path" + i, ":" + path);
        let finalImagePath = await this.getResizedImagePath(path, localImageOptions).then((path) => {
          return path;
        });
        if (finalImagePath != null && finalImagePath == path) {
          fs.unlink(path);
        }
        this.finishWithSuccess(finalImagePath);
      }
    }
  }

  handleVideoResult(path: string | null, shouldDeleteOriginalIfScaled: boolean): void {
    this.finishWithSuccess(path);
  }

  finishWithSuccess(path: string | null): void {

    Log.i(ImagePickerDelegate.TAG, path);
    let pathList: ArrayList<string> = new ArrayList();
    if (path != null) {
      let realPath = FileUtils.getPathFromUri(this.context as Context, path);
      Log.i(ImagePickerDelegate.TAG, "realPath :" + realPath);
      let file = fs.openSync(realPath, fs.OpenMode.READ_ONLY);
      if (realPath != null) {
        path = realPath;
      }
      pathList.add(realPath)
      pathList.add(file.fd.toString());
    }

    let localResult: Result<ArrayList<string>> | null = null;

    if (this.pendingCallState !== null) {
      localResult = this.pendingCallState.result;
    }
    this.pendingCallState = null;

    if (localResult == null) {
      if (!pathList.isEmpty()) {
        this.cache.saveResult(pathList, null, null);
      }
    } else {
      Log.i(ImagePickerDelegate.TAG, pathList[0]);
      localResult.success(pathList);
    }
  }

  finishWithListSuccess(path: ArrayList<string> | null): void {
    let localResult: Result<ArrayList<string>> | null = null;
    if (this.pendingCallState != null) {
      localResult = this.pendingCallState.result;
    }
    this.pendingCallState = null;

    if (localResult == null) {
      this.cache.saveResult(path as ArrayList<string>, null, null);
    } else if (path) {

      Log.i(ImagePickerDelegate.TAG, path[0]);
      let pathList: ArrayList<string> = new ArrayList();
      for (let i = 0; i < path.length; i++) {
        const element: string = path[i];
        let file = fs.openSync(element);
        pathList.add(element);
        pathList.add(file.fd.toString());
      }
      localResult.success(pathList as ArrayList<string>);
    }
  }

  async getResizedImagePath(path: string, outputOptions: ImageSelectionOptions): Promise<string> {
    return this.imageResizer.resizeImageIfNeeded(path, outputOptions.getMaxWidth(), outputOptions.getMaxHeight(),
      outputOptions.getQuality());
  }
}

interface OnPathReadyListener {
  onPathReady(path: string): void;
}

class PendingCallState {
  imageOptions: ImageSelectionOptions;
  videoOptions: VideoSelectionOptions;
  result: Result<ArrayList<string>>;

  constructor(imageOptions: ImageSelectionOptions | ESObject, videoOptions: VideoSelectionOptions | ESObject,
              result: Result<ArrayList<string>>) {
    this.imageOptions = imageOptions;
    this.videoOptions = videoOptions;
    this.result = result;
  }
}

export enum CameraDevice {
  REAR,
  FRONT
}