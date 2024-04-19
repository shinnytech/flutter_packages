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

import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { CreateMessage, LoopingMessage,
  MixWithOthersMessage,
  PlaybackSpeedMessage,
  PositionMessage,
  TextureMessage, VolumeMessage } from './Messages';
import { FlutterState } from './VideoPlayerPlugin';

export interface  VideoPlayerApi {
  initialize(): void;

  create(arg: CreateMessage) : TextureMessage;

  dispose(arg: TextureMessage): void;

  setLooping(arg: LoopingMessage): void;

  setVolume(arg: VolumeMessage): void;

  setPlaybackSpeed(arg: PlaybackSpeedMessage): void;

  play(arg: TextureMessage): void;

  position(arg: TextureMessage): PositionMessage;

  seekTo(arg: PositionMessage): void;

  pause(arg: TextureMessage): void;

  setMixWithOthers(arg: MixWithOthersMessage): void;

  setUp(flutterState: FlutterState): void;
}