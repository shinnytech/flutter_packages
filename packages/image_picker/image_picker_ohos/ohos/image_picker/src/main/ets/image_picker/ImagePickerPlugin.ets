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
import AbilityLifecycleCallback from '@ohos.app.ability.AbilityLifecycleCallback';

import AbilityAware from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityAware';

import {
  AbilityPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityPluginBinding';
import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import common from '@ohos.app.ability.common';
import Ability from '@ohos.app.ability.Ability';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { PluginRegistry } from '@ohos/flutter_ohos/src/main/ets/plugin/common/PluginRegistry';
import ImagePickerDelegate, { CameraDevice } from './ImagePickerDelegate';
import {
  GeneralOptions,
  ImagePickerApi,
  ImageSelectionOptions,
  SourceSpecification,
  Result,
  SourceType,
  MediaSelectionOptions,
  CacheRetrievalResult,
  VideoSelectionOptions,
  SourceCamera,
  FlutterError
} from './Messages';
import ImagePickerCache from './ImagePickerCache';
import ExifDataCopier from './ExifDataCopier';
import ImageResizer from './ImageResizer';
import UIAbility from '@ohos.app.ability.UIAbility';
import ArrayList from '@ohos.util.ArrayList';
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';

const TAG:string = "ImagePickerPlugin";
//export default class ImagePickerPlugin implements FlutterPlugin, AbilityAware, ImagePickerApi {
export default class ImagePickerPlugin implements FlutterPlugin, AbilityAware{
  private static TAG = "ImagePickerPlugin";
  private pluginBinding: FlutterPluginBinding;
  private state: AbilityState;

  getUniqueClassName(): string {
    return ImagePickerPlugin.TAG;
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.pluginBinding = binding;
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.pluginBinding = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    Log.i(TAG, "onAttachedToAbility");
    this.setup(this.pluginBinding.getBinaryMessenger(), this.pluginBinding.getApplicationContext(),
      binding.getAbility(), null, binding);
  }

  onDetachedFromAbility(): void {
    if (this.state != null) {
      this.state.release();
      this.state = null;
    }
  }

  setup(messenger: BinaryMessenger, context: common.Context, ability: UIAbility,
        registrar: PluginRegistry, binding: AbilityPluginBinding): void {
    this.state = new AbilityState(ability, null, messenger, this, registrar, binding, context);
  }

  constructor(delegate?: ImagePickerDelegate, ability?: UIAbility) {
    if (delegate != null && ability != null) {
      this.state = new AbilityState(ability, delegate);
    }
  }

  async pickImages(source: SourceSpecification, options: ImageSelectionOptions, generalOptions: GeneralOptions, result: Result<ArrayList<string>>): Promise<void> {
    let delegate: ImagePickerDelegate = this.getImagePickerDelegate();
    if (delegate == null) {
      let temp:Error =
      result.error(new FlutterError("no_ability", "image_picker plugin requires a foreground ability", null));
      return;
    }

    this.setCameraDevice(delegate, source);
    if (generalOptions.getAllowMultiple()) {
      delegate.chooseMultiImagesFromGallery(options, generalOptions.getUsePhotoPicker(), result);
    } else {
      switch (source.getType()) {
        case SourceType.GALLERY: {
          await delegate.chooseImageFromGallery(options, generalOptions.getUsePhotoPicker(), result);
          break;
        }
        case SourceType.CAMERA: {
          delegate.takeImageWithCamera(options, result);
        }
      }
    }
  }

  pickVideos(source: SourceSpecification, options: VideoSelectionOptions, generalOptions: GeneralOptions, result: Result<ArrayList<string>>): void {
    let delegate: ImagePickerDelegate = this.getImagePickerDelegate();
    if (delegate == null) {
      result.error(new FlutterError("no_ability", "image_pickerplugin requires a foreground ability", null));
      return;
    }

    this.setCameraDevice(delegate, source);
    if (generalOptions.getAllowMultiple()) {
      result.error(new FlutterError("no_ability", "image_pickerplugin requires a foreground ability", null));
    } else {
      switch (source.getType()) {
        case SourceType.GALLERY: {
          delegate.chooseVideoFromGallery(options, generalOptions.getUsePhotoPicker(), result);
          break;
        }
        case SourceType.CAMERA: {
          delegate.takeVideoWithCamera(options, result);
        }
      }
    }
  }

  pickMedia(mediaSelectionOptions: MediaSelectionOptions, generalOptions: GeneralOptions, result: Result<ArrayList<string>>): void {
    let delegate: ImagePickerDelegate = this.getImagePickerDelegate();
    if (delegate == null) {
      result.error(new FlutterError("no_ability", "image_pickerplugin requires a foreground ability", null));
      return;
    }
    delegate.chooseMediaFromGallery(mediaSelectionOptions, generalOptions, result);
  }

  async retrieveLostResults(): Promise<CacheRetrievalResult> {
    let delegate = this.getImagePickerDelegate();
    if (delegate == null) {
      throw new FlutterError("no_ability", "image_picker plugin requires a foreground ability", null);
    }
    return await delegate.retrieveLostImage().then((result) => {
      return result;
    });
  }

  getAbilityState(): AbilityState {
    return this.state;
  }

  static constructorDelegate(setupAbility: UIAbility): ImagePickerDelegate {
    let cache: ImagePickerCache = new ImagePickerCache(setupAbility.context);
    let exifDataCopier: ExifDataCopier = new ExifDataCopier();
    let imageResizer: ImageResizer = new ImageResizer(setupAbility.context, exifDataCopier);
    return new ImagePickerDelegate(setupAbility, imageResizer, cache);
  }

  getImagePickerDelegate(): ImagePickerDelegate {
    if (this.state == null || this.state.getAbility() == null) {
      return null;
    }
    return this.state.getDelegate();
  }

  setCameraDevice(delegate: ImagePickerDelegate, source: SourceSpecification) {
    let camera: SourceCamera = source.getCamera();
    if (camera != null) {
      let device: CameraDevice;
      switch (camera) {
        case SourceCamera.FRONT: {
          device = CameraDevice.FRONT;
          break;
        }
        case SourceCamera.REAR: {
          device = CameraDevice.REAR;
          break;
        }
      }
      delegate.setCameraDevice(device);
    }
  }
}

class AbilityState {
  private ability: UIAbility;
  private context: common.Context;
  private abilityBinding: AbilityPluginBinding;
  private messenger: BinaryMessenger;
  private delegate: ImagePickerDelegate;
  private abilityLifecycleCallback: AbilityLifecycleCallback;

  constructor(ability: UIAbility, delegate?: ImagePickerDelegate, messenger?: BinaryMessenger, handler?: ImagePickerApi,
    registrar?: PluginRegistry, abilityBinding?: AbilityPluginBinding, context?: common.Context) {
    this.ability = ability;
    if (context) {
      this.context = context;
    }
    if (abilityBinding) {
      this.abilityBinding = abilityBinding;
    }
    if (messenger) {
      this.messenger = messenger;
    }
    if (delegate) {
      this.delegate = delegate;
    }

    this.abilityLifecycleCallback = {
      onAbilityCreate(ability) {
        console.log('AbilityLifecycleCallback onAbilityCreate.');
      },
      onWindowStageCreate(ability, windowStage) {
        console.log('AbilityLifecycleCallback onWindowStageCreate.');
      },
      onWindowStageActive(ability, windowStage) {
        console.log('AbilityLifecycleCallback onWindowStageActive.');
      },
      onWindowStageInactive(ability, windowStage) {
        console.log('AbilityLifecycleCallback onWindowStageInactive.');
      },
      onWindowStageDestroy(ability, windowStage) {
        console.log('AbilityLifecycleCallback onWindowStageDestroy.');
      },
      onAbilityDestroy(ability) {
        console.log('AbilityLifecycleCallback onAbilityDestroy.');
      },
      onAbilityForeground(ability) {
        console.log('AbilityLifecycleCallback onAbilityForeground.');
      },
      onAbilityBackground(ability) {
        console.log('AbilityLifecycleCallback onAbilityBackground.');
      },
      onAbilityContinue(ability) {
        console.log('AbilityLifecycleCallback onAbilityContinue.');
      }
    };

    this.delegate = ImagePickerPlugin.constructorDelegate(this.ability);
    ImagePickerApi.setup(messenger, handler);
    if (registrar != null) {
      let applicationContext = this.context.getApplicationContext();
      //globalThis.lifecycleId = applicationContext.on("abilityLifecycle", this.abilityLifecycleCallback);
    } else {

    }
  }

  release(): void {
    if (this.abilityBinding != null) {
      this.abilityBinding = null;
    }

    ImagePickerApi.setup(null, null);

    this.ability = null;
    this.delegate = null;
  }

  getAbility(): Ability {
    return this.ability;
  }

  getDelegate(): ImagePickerDelegate {
    return this.delegate;
  }
}
