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

import media from '@ohos.multimedia.media';

class FlutterError extends Error {
  /** The error code. */
  public code: string;

  /** The error details. Must be a datatype supported by the api codec. */
  public details: ESObject;

  constructor(code: string, message: string, details: ESObject) {
    super(message);
    this.code = code;
    this.details = details;
  }
}

export function wrapError(exception: Error): Array<Object> {
  let errorList = new Array<Object>();
  if (exception instanceof FlutterError) {
    let error = exception as FlutterError;
    errorList.push(error.code);
    errorList.push(error.message);
    errorList.push(error.details);
  } else {
    errorList.push(exception.toString());
    errorList.push(exception.name);
    errorList.push(
      "Cause: " + exception.message + ", Stacktrace: " + exception.stack);
  }
  return errorList;
}

export class CreateMessage {
  constructor() {
  }
  private asset: String = "";

  public getAsset(): String {
    return this.asset;
  }

  public setAsset(setterArg: String): void {
  this.asset = setterArg;
  }

  private uri: string = "";

  public getUri(): string  {
    return this.uri;
  }

  public setUri(setterArg: string): void {
    this.uri = setterArg;
  }

  private packageName: String = "";

  public getPackageName(): String{
    return this.packageName;
  }

  public setPackageName(setterArg: String): void {
    this.packageName = setterArg;
  }

  private formatHint: String = "";

  public getFormatHint(): String {
    return this.formatHint;
  }

  public setFormatHint(setterArg: String): void {
    this.formatHint = setterArg;
  }

  private  httpHeaders: Map<String, String> = new Map<String, String>();

  public getHttpHeaders(): Map<String, String> {
    return this.httpHeaders;
  }

  public setHttpHeaders(setterArg: Map<String, String>): void {
    if (setterArg == null) {
      // throw new IllegalStateException("Nonnull field \"httpHeaders\" is null.");
    }
    this.httpHeaders = setterArg;
  }


  toList(): Array<Object>  {
    let toListResult: Array<Object> = new Array<Object>(5);
    toListResult[0] = this.asset;
    toListResult[1] = this.uri;
    toListResult[2] = this.packageName;
    toListResult[3] = this.formatHint;
    toListResult[4] = this.httpHeaders;
    return toListResult;
  }


  static fromList(list: Array<Object>): CreateMessage {
    let pigeonResult: CreateMessage = new CreateMessage();
    pigeonResult.setAsset(list[0] as String);
    pigeonResult.setUri(list[1] as string);
    pigeonResult.setPackageName(list[2] as String);
    pigeonResult.setFormatHint(list[3] as String);
    pigeonResult.setHttpHeaders(list[4] as Map<String, String>);
    return pigeonResult;
  }
}

export class LoopingMessage {
  constructor() {
  }
  private textureId: Number = 0;

  public getTextureId(): Number {
    return this.textureId;
  }

  public setTextureId(setterArg: Number): void{
    if (setterArg == null) {
      // throw new IllegalStateException("Nonnull field \"textureId\" is null.");
    } else {
      this.textureId = setterArg;
    }
  }

  private isLooping: boolean = false;

  public getIsLooping(): boolean {
    return this.isLooping;
  }

  public setIsLooping(setterArg: boolean): void {
    if (setterArg == null) {
      // throw new IllegalStateException("Nonnull field \"isLooping\" is null.");
    }
    this.isLooping = setterArg;
  }

// public static final class Builder {
//
//   private @Nullable Long textureId;
//
//   public @NonNull Builder setTextureId(@NonNull Long setterArg) {
//   this.textureId = setterArg;
//   return this;
// }
//
// private @Nullable Boolean isLooping;
//
// public @NonNull Builder setIsLooping(@NonNull Boolean setterArg) {
//   this.isLooping = setterArg;
//   return this;
// }
//
// public @NonNull LoopingMessage build() {
//         LoopingMessage pigeonReturn = new LoopingMessage();
//         pigeonReturn.setTextureId(textureId);
//         pigeonReturn.setIsLooping(isLooping);
//         return pigeonReturn;
//       }
// }
  toList(): Array<Object> {
    let toListResult: Array<Object> = new Array<Object>(2);
    toListResult[0] = this.textureId;
    toListResult[1] = this.isLooping;
    return toListResult;
  }

  static fromList(list: Array<Object> ): LoopingMessage {
    let pigeonResult: LoopingMessage = new LoopingMessage();
    let textureId = list[0] as Number ?? 0;
    pigeonResult.setTextureId(textureId);

    let isLooping = list[1] as boolean;
    pigeonResult.setIsLooping(isLooping);
    return pigeonResult;
  }

}

export class MixWithOthersMessage {
  constructor() {
  }

  private mixWithOthers: Boolean = false;

  public getMixWithOthers(): Boolean {
    return this.mixWithOthers;
  }

  public setMixWithOthers(setterArg: Boolean): void {
    if (setterArg == null) {
      // throw new IllegalStateException("Nonnull field \"mixWithOthers\" is null.");
    }
    this.mixWithOthers = setterArg;
  }

// public static final class Builder {
//
//   private @Nullable Boolean mixWithOthers;
//
//   public @NonNull Builder setMixWithOthers(@NonNull Boolean setterArg) {
//   this.mixWithOthers = setterArg;
//   return this;
// }
// public @NonNull MixWithOthersMessage build() {
//         MixWithOthersMessage pigeonReturn = new MixWithOthersMessage();
//         pigeonReturn.setMixWithOthers(mixWithOthers);
//         return pigeonReturn;
//       }
// }

  toList(): Array<Object> {
    let toListResult: Array<Object> = new Array<Object>(1);
    toListResult[0] = this.mixWithOthers;
    return toListResult;
  }

  static fromList(list: Array<Object>): MixWithOthersMessage {
    let pigeonResult: MixWithOthersMessage = new MixWithOthersMessage();
    let mixWithOthers = list[0] as Boolean;
    pigeonResult.setMixWithOthers(mixWithOthers);
    return pigeonResult;
  }
}

export class PlaybackSpeedMessage {
  constructor() {
  }
  private textureId: Number = 0;

  public getTextureId(): Number {
    return this.textureId;
  }

  public setTextureId(setterArg: Number): void{
    if (setterArg == null) {
      // throw new IllegalStateException("Nonnull field \"textureId\" is null.");
    } else {
      this.textureId = setterArg;
    }
  }

  private speed: media.PlaybackSpeed = media.PlaybackSpeed.SPEED_FORWARD_1_00_X;

  public getSpeed(): media.PlaybackSpeed {
    return this.speed;
  }

  public setSpeed(setterArg: media.PlaybackSpeed): void {
    this.speed = setterArg;
  }


// public static final class Builder {
//
//   private @Nullable Long textureId;
//
//   public @NonNull Builder setTextureId(@NonNull Long setterArg) {
//   this.textureId = setterArg;
//   return this;
// }
//
// private @Nullable Double speed;
//
// public @NonNull Builder setSpeed(@NonNull Double setterArg) {
//   this.speed = setterArg;
//   return this;
// }
//
// public @NonNull PlaybackSpeedMessage build() {
//         PlaybackSpeedMessage pigeonReturn = new PlaybackSpeedMessage();
//         pigeonReturn.setTextureId(textureId);
//         pigeonReturn.setSpeed(speed);
//         return pigeonReturn;
//       }
// }

  toList(): Array<Object>  {
      let toListResult: Array<Object>  = new Array<Object>();
      toListResult[0] = this.textureId;
      toListResult[1] = this.speed;
      return toListResult;
    }

  static fromList(list: Array<Object>): PlaybackSpeedMessage {
    let pigeonResult: PlaybackSpeedMessage = new PlaybackSpeedMessage();
    let textureId = list[0] as Number ?? 0;
    pigeonResult.setTextureId(textureId);
    let speed = list[1] as media.PlaybackSpeed;
    pigeonResult.setSpeed(speed);
    return pigeonResult;
  }
}

export class PositionMessage {
  constructor() {
  }
  private textureId: Number = 0;

  public getTextureId(): Number {
    return this.textureId;
  }

  public setTextureId(setterArg: Number): void{
    this.textureId = setterArg;
  }

  private position: Number = 0;

  public getPosition(): Number {
    return this.position;
  }

  public setPosition(setterArg: Number): void {
    this.position = setterArg;
  }


// public static final class Builder {
//
//   private @Nullable Long textureId;
//
//   public @NonNull Builder setTextureId(@NonNull Long setterArg) {
//   this.textureId = setterArg;
//   return this;
// }
//
// private @Nullable Long position;
//
// public @NonNull Builder setPosition(@NonNull Long setterArg) {
//   this.position = setterArg;
//   return this;
// }
//
// public @NonNull PositionMessage build() {
//         PositionMessage pigeonReturn = new PositionMessage();
//         pigeonReturn.setTextureId(textureId);
//         pigeonReturn.setPosition(position);
//         return pigeonReturn;
//       }
// }

  toList(): Array<Object> {
    let toListResult: Array<Object> = new Array<Object>();
    toListResult[0] = this.textureId;
    toListResult[1] = this.position;
    return toListResult;
  }

  static fromList(list: Array<Object>): PositionMessage {
    let pigeonResult: PositionMessage = new PositionMessage();
    let textureId = list[0] as Number ?? 0;
    pigeonResult.setTextureId(textureId);
    let position = list[1] as Number ?? 0;
    pigeonResult.setPosition(position);
    return pigeonResult;
  }
}

export class TextureMessage {

  private textureId: Number = 0;

  public getTextureId(): Number {
    return this.textureId;
  }

  public setTextureId(setterArg: Number): void {
    this.textureId = setterArg;
  }


// public static final class Builder {
//
//   private  Long textureId;
//
//   public  Builder setTextureId( Long setterArg) {
//   this.textureId = setterArg;
//   return this;
// }
//
// public  TextureMessage build() {
//         TextureMessage pigeonReturn = new TextureMessage();
//         pigeonReturn.setTextureId(textureId);
//         return pigeonReturn;
//       }
// }


 toList(): Array<Object> {
      let toListResult: Array<Object> = new Array<Object>(1);
      toListResult[0] = this.textureId;
      return toListResult;
    }
  static fromList(list: Array<Object>): TextureMessage {
    let pigeonResult: TextureMessage = new TextureMessage();
    let textureId = list[0] as Number ?? 0;
    pigeonResult.setTextureId(textureId);
    return pigeonResult;
  }
}

export class VolumeMessage {
  constructor() {
  }
  private textureId: Number = 0;

  public getTextureId(): Number {
    return this.textureId;
  }

  public setTextureId(setterArg: Number): void {
    this.textureId = setterArg;
  }

  private volume: Number = 0;
  public getVolume(): Number {
    return this.volume;
  }

  public setVolume(setterArg: Number): void {
    this.volume = setterArg;
  }
// public static final class Builder {
//
//   private  Long textureId;
//
//   public Builder setTextureId( Long setterArg) {
//   this.textureId = setterArg;
//   return this;
// }
//
// private Double volume;
//
// public Builder setVolume(Double setterArg) {
//   this.volume = setterArg;
//   return this;
// }
//
// public VolumeMessage build() {
//         VolumeMessage pigeonReturn = new VolumeMessage();
//         pigeonReturn.setTextureId(textureId);
//         pigeonReturn.setVolume(volume);
//         return pigeonReturn;
//       }
// }


 toList(): Array<Object> {
   let toListResult: Array<Object> = new Array<Object>(2);
   toListResult[0] = this.textureId;
   toListResult[1] = this.volume;
   return toListResult;
 }

  static fromList(list: Array<Object> ): VolumeMessage {
    let pigeonResult: VolumeMessage = new VolumeMessage();
    let textureId = list[0] as Number ?? 0;
    pigeonResult.setTextureId(textureId);
    let volume = list[1] as Number ?? 0;
    pigeonResult.setVolume(volume);
    return pigeonResult;
  }
}