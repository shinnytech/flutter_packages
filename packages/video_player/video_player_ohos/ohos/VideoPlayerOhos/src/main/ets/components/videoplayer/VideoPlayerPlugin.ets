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

import AbilityAware from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityAware';
import { AbilityPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityPluginBinding';
import { FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { TextureRegistry } from '@ohos/flutter_ohos/src/main/ets/view/TextureRegistry';
import { VideoPlayerApi } from './VideoPlayerApi';
import { VideoPlayerApiImpl } from './VideoPlayerApiImpl';

const TAG: string = "VideoPlayerPlugin";
export class VideoPlayerPlugin implements FlutterPlugin, AbilityAware {
  private pluginBinding: FlutterPluginBinding | null = null;
  private videoPlayerApi: VideoPlayerApiImpl | null = null;
  private flutterState: FlutterState | null = null;

  getUniqueClassName(): string {
    return TAG;
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.pluginBinding = binding;
    Log.i(TAG, "VideoPlayer onAttachedToEngine");
    this.flutterState = new FlutterState(this.pluginBinding.getBinaryMessenger(), this.pluginBinding.getTextureRegistry());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.pluginBinding = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    Log.i(TAG, "VideoPlayer onAttachedToAbility");
    if (this.flutterState != null && this.pluginBinding != null) {
      this.videoPlayerApi = new VideoPlayerApiImpl(this.flutterState, binding);
      this.videoPlayerApi.setup(this.pluginBinding.getBinaryMessenger());
    }
  }
  onDetachedFromAbility(): void {
    this.videoPlayerApi = null;
  }
}

export class FlutterState {
  private binaryMessenger: BinaryMessenger;
  private textureRegistry: TextureRegistry;

  constructor(binaryMessenger: BinaryMessenger, textureRegistry: TextureRegistry) {
    this.binaryMessenger = binaryMessenger;
    this.textureRegistry = textureRegistry;
  }

  getBinaryMessenger(): BinaryMessenger {
    return this.binaryMessenger;
  }

  getTextureRegistry(): TextureRegistry {
    return this.textureRegistry;
  }
}