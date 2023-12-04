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
import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';
import { ByteBuffer } from '@ohos/flutter_ohos/src/main/ets/util/ByteBuffer';
import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import BasicMessageChannel from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';

export enum SourceCamera {
  REAR = 0,
  FRONT = 1
}

export enum SourceType {
  CAMERA = 0,
  GALLERY = 1
}

export enum CacheRetrievalType {
  IMAGE = 0,
  VIDEO = 1
}

const TAG: string = "Message";
export default class Messages {
  static wrapError(exception: Error): ArrayList<ESObject> {
    const errorList: ArrayList<ESObject> = new ArrayList<ESObject>();
    if (exception instanceof FlutterError) {
      const error = exception;
      errorList.add(error.code);
      errorList.add(error.message);
      errorList.add(error.details);
    } else {
      errorList.add(exception.name);
      errorList.add(exception.message);
      errorList.add(exception.stack);
    }
    return errorList;
  }
}

export class FlutterError extends Error {
  code: string;
  details: ESObject;

  constructor(code: string, message: string, details: ESObject) {
    super(message);
    this.code = code;
    this.details = details;
  }
}
class GeneralOptionsBuilder{
  setAllowMultiple:(setterArg: boolean)=>ESObject

  setUsePhotoPicker:(setterArg: boolean)=>ESObject

  build:()=>ESObject

  constructor(setAllowMultiple:(setterArg: boolean)=>ESObject, setUsePhotoPicker:(setterArg: boolean)=>ESObject ,build:()=>ESObject) {
    this.setAllowMultiple = setAllowMultiple
    this.setUsePhotoPicker = setUsePhotoPicker
    this.build = build
  }
}
export class GeneralOptions {
  private static allowMultiple: boolean;
  private static usePhotoPicker: boolean;

  private constructor() {
  }

  getAllowMultiple(): boolean {
    return GeneralOptions.allowMultiple;
  }

  setAllowMultiple(setterArg: boolean): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"allowMultiple\" is null.");
    }
    GeneralOptions.allowMultiple = setterArg;
  }

  getUsePhotoPicker(): boolean {
    return GeneralOptions.usePhotoPicker;
  }

  setUsePhotoPicker(setterArg: boolean): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"usePhotoPicker\" is null.");
    }
    GeneralOptions.usePhotoPicker = setterArg;
  }

  public static Builder:ESObject =new GeneralOptionsBuilder((setterArg: boolean)=>{
    this.allowMultiple = setterArg;
    return this;
  },(setterArg: boolean)=>{
    this.usePhotoPicker = setterArg;
    return this;
    },():ESObject=>{
      const pigeonReturn:ESObject = new GeneralOptions();
      pigeonReturn.setAllowMultiple(this.allowMultiple);
      pigeonReturn.setUsePhotoPicker(this.usePhotoPicker);
      return pigeonReturn;
    }
  )

  toList(): ArrayList<ESObject> {
    const toListResult:ArrayList<ESObject> = new ArrayList<ESObject>();
    toListResult.add(GeneralOptions.allowMultiple);
    toListResult.add(GeneralOptions.usePhotoPicker);
    return toListResult;
  }

  static fromList(list: ArrayList<ESObject>): GeneralOptions {
    const pigeonResult = new GeneralOptions();
    const allowMultiple:ESObject = list[0];
    pigeonResult.setAllowMultiple(allowMultiple);
    const usePhotoPicker:ESObject = list[1];
    pigeonResult.setUsePhotoPicker(usePhotoPicker);
    return pigeonResult;
  }
}

class ImageSelectionOptionsBuilder{
  setMaxWidth :(setterArg: number)=>ESObject
  setMaxHeight:(setterArg: number)=>ESObject
  setQuality:(setterArg: number)=>ESObject
  build:()=>ESObject

  constructor(setMaxWidth :(setterArg: number)=>ESObject, setMaxHeight:(setterArg: number)=>ESObject, setQuality:(setterArg: number)=>ESObject, build:()=>ESObject) {
    this.setMaxWidth = setMaxWidth
    this.setMaxHeight = setMaxHeight
    this.setQuality = setQuality
    this.build = build
  }
}
export class ImageSelectionOptions {
  private static maxWidth: number;
  private static maxHeight: number;
  private static quality: number;

  private constructor() {
  }

  getMaxWidth(): number {
    return ImageSelectionOptions.maxWidth;
  }

  setMaxWidth(setterArg: number): void {
    ImageSelectionOptions.maxWidth = setterArg;
  }

  getMaxHeight(): number {
    return ImageSelectionOptions.maxHeight;
  }

  setMaxHeight(setterArg: number): void {
    ImageSelectionOptions.maxHeight = setterArg;
  }

  getQuality(): number {
    return ImageSelectionOptions.quality;
  }

  setQuality(setterArg: number): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"quality\" is null.")
    }
    ImageSelectionOptions.quality = setterArg;
  }

  public static Builder = new ImageSelectionOptionsBuilder((setterArg: number)=>{
    this.maxWidth = setterArg;
    return this;
  },

    (setterArg: number)=>{
      this.maxHeight = setterArg;
      return this ;
    },

    (setterArg: number)=>{
      this.quality = setterArg;
      return this;
    },
    ()=>{
      const pigeonReturn = new ImageSelectionOptions();
      pigeonReturn.setMaxWidth(this.maxWidth);
      pigeonReturn.setMaxHeight(this.maxHeight);
      pigeonReturn.setQuality(this.quality);
      return pigeonReturn;
    }

  )
  toList(): ArrayList<ESObject> {
    const toListResult:ArrayList<ESObject> = new ArrayList<ESObject>();
    toListResult.add(ImageSelectionOptions.maxWidth);
    toListResult.add(ImageSelectionOptions.maxHeight);
    toListResult.add(ImageSelectionOptions.quality);
    return toListResult;
  }

  static fromList(list: ArrayList<ESObject>): ImageSelectionOptions {
    const pigeonResult = new ImageSelectionOptions();
    const maxWidth:ESObject = list[0];
    pigeonResult.setMaxWidth(maxWidth);
    const maxHeight:ESObject = list[1];
    pigeonResult.setMaxHeight(maxHeight);
    const quality:ESObject = list[2];
    pigeonResult.setQuality(quality);
    return pigeonResult;
  }
}

class MediaSelectionOptionsBuilder{
  setImageSelectionOptions:(setterArg: ImageSelectionOptions)=>ESObject
  build:()=>ESObject
  constructor(setImageSelectionOptions :(setterArg: ImageSelectionOptions)=>ESObject ,  build:()=>ESObject) {
    this.setImageSelectionOptions = setImageSelectionOptions
    this.build = build
  }
}
export class MediaSelectionOptions {
  private imageSelectionOptions: ImageSelectionOptions;
  static imageSelectionOptions: ImageSelectionOptions;

  private constructor() {
  }

  getImageSelectionOptions(): ImageSelectionOptions {
    return this.imageSelectionOptions;
  }

  setImageSelectionOptions(setterArg: ImageSelectionOptions): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"imageSelectionOptions\" is null.")
    }
    this.imageSelectionOptions = setterArg;
  }

  public static Builder = new MediaSelectionOptionsBuilder(
    (setterArg: ImageSelectionOptions)=>{
      this.imageSelectionOptions = setterArg;
      return this;
  }, ()=>{
      const pigeonReturn = new MediaSelectionOptions();
      pigeonReturn.setImageSelectionOptions(this.imageSelectionOptions);
      return pigeonReturn;
  }
  )

  toList(): ArrayList<ESObject> {
    const toListResult:ArrayList<ESObject> = new ArrayList<ESObject>();
    toListResult.add(this.imageSelectionOptions == null ? null : this.imageSelectionOptions.toList());
    return toListResult;
  }

  static fromList(list: ArrayList<ESObject>): MediaSelectionOptions {
    const pigeonResult = new MediaSelectionOptions();
    const imageSelectionOptions:ESObject = list[0];
    pigeonResult.setImageSelectionOptions(imageSelectionOptions == null ?
      null : ImageSelectionOptions.fromList(imageSelectionOptions));
    return pigeonResult;
  }
}

class VideoSelectionOptionsBuilder{
  setMaxDurationSeconds:(setterArg: number)=>ESObject
  build:()=>ESObject
  constructor(setMaxDurationSeconds:(setterArg: number)=>ESObject ,  build:()=>ESObject) {
    this.setMaxDurationSeconds = setMaxDurationSeconds
    this.build = build
  }
}

export class VideoSelectionOptions {
  private maxDurationSeconds: number;
  static maxDurationSeconds: number;

  private constructor() {
  }

  getMaxDurationSeconds(): number {
    return this.maxDurationSeconds;
  }

  setMaxDurationSeconds(setterArg: number): void {
    this.maxDurationSeconds = setterArg;
  }

  public static Builder = new VideoSelectionOptionsBuilder((setterArg: number)=>{
      this.maxDurationSeconds = setterArg;
      return this;
    },
    ()=>{
      const pigeonReturn = new VideoSelectionOptions();
      pigeonReturn.setMaxDurationSeconds(this.maxDurationSeconds);
      return pigeonReturn;
    })

  toList(): ArrayList<ESObject> {
    const toListResult:ArrayList<ESObject> = new ArrayList<ESObject>();
    toListResult.add(this.maxDurationSeconds);
    return toListResult;
  }

  static fromList(list: ArrayList<ESObject>): VideoSelectionOptions {
    const pigeonResult = new VideoSelectionOptions();
    const maxDurationSeconds:ESObject = list[0];
    pigeonResult.setMaxDurationSeconds(maxDurationSeconds);
    return pigeonResult;
  }
}
class SourceSpecificationBuilder{
  setType : (setterArg: SourceType)=>ESObject
  setCamera : (setterArg: SourceCamera)=>ESObject
  build:()=>ESObject

  constructor(setType : (setterArg: SourceType)=>ESObject, setCamera : (setterArg: SourceCamera)=>ESObject, build:()=>ESObject) {
    this.setType = setType
    this.setCamera = setCamera
    this.build = build
  }
}
export class SourceSpecification {
  private static type: SourceType;
  private static camera: SourceCamera;

  private constructor() {
  }

  getType(): SourceType {
    return SourceSpecification.type;
  }

  setType(setterArg: SourceType): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"type\" is null.")
    }
    SourceSpecification.type = setterArg;
  }

  getCamera(): SourceCamera {
    return SourceSpecification.camera;
  }

  setCamera(setterArg: SourceCamera): void {
    SourceSpecification.camera = setterArg;
  }

  public static Builder =new SourceSpecificationBuilder(
    (setterArg: SourceType)=>{
        this.type = setterArg;
        return this;
    },
    (setterArg: SourceCamera)=>{
      this.camera = setterArg;
      return this;
    },
    ()=>{
      const pigeonReturn = new SourceSpecification();
      pigeonReturn.setType(this.type);
      pigeonReturn.setCamera(this.camera);
      return pigeonReturn;
    }
  )

  toList(): ArrayList<ESObject> {
    const toListResult:ArrayList<ESObject> = new ArrayList<ESObject>();
    toListResult.add(SourceSpecification.type);
    toListResult.add(SourceSpecification.camera);
    return toListResult;
  }

  static fromList(list: ArrayList<ESObject>): SourceSpecification {
    const pigeonResult = new SourceSpecification();
    const type:ESObject = list[0];
    pigeonResult.setType(type);
    const camera:ESObject = list[1];
    pigeonResult.setCamera(camera);
    return pigeonResult;
  }
}

export class CacheRetrievalErrorBuilder{
    setCode:(setterArg: string)=>ESObject
    setMessage:(setterArg: string)=>ESObject
    build:()=>ESObject
    constructor(setCode:(setterArg: string)=>ESObject, setMessage:(setterArg: string)=>ESObject, build:()=>ESObject) {
      this.setCode = setCode
      this.setMessage = setMessage
      this.build = build
    }
}
export class CacheRetrievalError {
  private static code: string;
  private static message: string;

  private constructor() {
  }

  getCode(): string {
    return CacheRetrievalError.code;
  }

  setCode(setterArg: string): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"code\" is null.")
    }
    CacheRetrievalError.code = setterArg;
  }

  getMessage(): string {
    return CacheRetrievalError.message;
  }

  setMessage(setterArg: string): void {
    CacheRetrievalError.message = setterArg;
  }

  static Builder =new CacheRetrievalErrorBuilder(
    (setterArg: string)=>{
      CacheRetrievalError.code = setterArg;
      return this;
    },
    (setterArg: string)=>{
      this.message = setterArg;
      return this ;
    },
    ()=>{
      const pigeonReturn = new CacheRetrievalError();
      pigeonReturn.setCode(this.code);
      pigeonReturn.setMessage(this.message);
      return pigeonReturn;
    }
  )

  toList(): ArrayList<ESObject> {
    const toListResult:ArrayList<ESObject> = new ArrayList<ESObject>();
    toListResult.add(CacheRetrievalError.code);
    toListResult.add(CacheRetrievalError.message);
    return toListResult;
  }

  static fromList(list: ArrayList<ESObject>): CacheRetrievalError {
    const pigeonResult = new CacheRetrievalError();
    const code:ESObject = list[0];
    pigeonResult.setCode(code);
    const message:ESObject = list[1];
    pigeonResult.setMessage(message);
    return pigeonResult;
  }
}

export class CacheRetrievalResultBuilder{

  private type: CacheRetrievalType
  private error: CacheRetrievalError
  private paths: ArrayList<string>

  setType:(setterArg: CacheRetrievalType)=>ESObject
  setError:(setterArg: CacheRetrievalError)=>ESObject
  setPaths:(setterArg: ArrayList<string>)=>ESObject
  build:()=>ESObject

  constructor(setType:(setterArg: CacheRetrievalType)=>ESObject,setError:(setterArg: CacheRetrievalError)=>ESObject,setPaths:(setterArg: ArrayList<string>)=>ESObject,build:()=>ESObject) {
    this.setType = setType
    this.setError = setError
    this.setPaths = setPaths
    this.build = build
  }
}

export class CacheRetrievalResult {
  private static type: CacheRetrievalType;
  private static error: CacheRetrievalError;
  private static paths: ArrayList<string>;

  private constructor() {
  }

  getType(): CacheRetrievalType {
    return CacheRetrievalResult.type;
  }

  setType(setterArg: CacheRetrievalType): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"type\" is null.")
    }
    CacheRetrievalResult.type = setterArg;
  }

  getError(): CacheRetrievalError {
    return CacheRetrievalResult.error;
  }

  setError(setterArg: CacheRetrievalError): void {
    CacheRetrievalResult.error = setterArg;
  }

  getPaths(): ArrayList<string> {
    return CacheRetrievalResult.paths;
  }

  setPaths(setterArg: ArrayList<string>): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"paths\" is null.")
    }
    CacheRetrievalResult.paths = setterArg;
  }

  public static Builder = new CacheRetrievalResultBuilder(
    (setterArg: CacheRetrievalType)=>{
    this.type = setterArg;
    return this;
  },
    (setterArg: CacheRetrievalError)=>{
      this.error = setterArg;
      return this;
    },
    (setterArg: ArrayList<string>)=>{
      this.paths = setterArg;
      return this;
    },
    ()=>{
      const pigeonReturn = new CacheRetrievalResult();
      pigeonReturn.setType(this.type);
      pigeonReturn.setError(this.error);
      pigeonReturn.setPaths(this.paths);
      return pigeonReturn;
    })


  toList(): ArrayList<ESObject> {
    const toListResult:ArrayList<ESObject> = new ArrayList<ESObject>();
    toListResult.add(CacheRetrievalResult.type);
    toListResult.add(CacheRetrievalResult.error == null ? null : CacheRetrievalResult.error.toList());
    toListResult.add(CacheRetrievalResult.paths);
    return toListResult;
  }

  static fromList(list: ArrayList<ESObject>): CacheRetrievalResult {
    const pigeonResult = new CacheRetrievalResult();
    const type:ESObject = list[0];
    pigeonResult.setType(type);
    const error:ESObject = list[1];
    pigeonResult.setError(error == null ? null : CacheRetrievalError.fromList(error));
    const paths:ESObject = list[2];
    pigeonResult.setPaths(paths);
    return pigeonResult;
  }
}

export interface Result<T> {
  success(result: T): void;

  error(error: Error|ESObject);
}

export class ImagePickerApiCodec extends StandardMessageCodec {
  static INSTANCE = new ImagePickerApiCodec();

  private constructor() {
    super();
  }

  readValueOfType(type: number, buffer: ByteBuffer): ESObject {
    switch (type) {
      case 128:
        return CacheRetrievalError.fromList(this.readValue(buffer));
      case -127:
        return CacheRetrievalResult.fromList(this.readValue(buffer));
      case -126:
        return GeneralOptions.fromList(this.readValue(buffer));
      case -125:
        return ImageSelectionOptions.fromList(this.readValue(buffer));
      case -124:
        return MediaSelectionOptions.fromList(this.readValue(buffer));
      case -123:
        return SourceSpecification.fromList(this.readValue(buffer));
      case -122:
        return VideoSelectionOptions.fromList(this.readValue(buffer));
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  writeValue(stream: ByteBuffer, value: ESObject): void {
    if (value instanceof CacheRetrievalError) {
      stream.writeInt8(128);
      super.writeValue(stream, value.toList());
    } else if (value instanceof CacheRetrievalResult) {
      stream.writeInt8(-127);
      super.writeValue(stream, value.toList());
    } else if (value instanceof GeneralOptions) {
      stream.writeInt8(-126);
      super.writeValue(stream, value.toList());
    } else if (value instanceof ImageSelectionOptions) {
      stream.writeInt8(-125);
      super.writeValue(stream, value.toList());
    } else if (value instanceof MediaSelectionOptions) {
      stream.writeInt8(-124);
      super.writeValue(stream, value.toList());
    } else if (value instanceof SourceSpecification) {
      stream.writeInt8(-123);
      super.writeValue(stream, value.toList());
    } else if (value instanceof VideoSelectionOptions) {
      stream.writeInt8(-122);
      super.writeValue(stream, value.toList());
    } else {
      super.writeValue(stream, value);
    }
  }
}

export abstract class ImagePickerApi {
  abstract pickImages(
    source: SourceSpecification,
    options: ImageSelectionOptions,
    generalOptions: GeneralOptions,
    result: Result<ArrayList<string>>): void;

  abstract pickVideos(
    source: SourceSpecification,
    options: VideoSelectionOptions,
    generalOptions: GeneralOptions,
    result: Result<ArrayList<string>>): void;

  abstract pickMedia(
    mediaSelectionOptions: MediaSelectionOptions,
    generalOptions: GeneralOptions,
    result: Result<ArrayList<string>>): void;

  abstract retrieveLostResults(): Promise<CacheRetrievalResult>;

  static getCodec(): MessageCodec<ESObject> {
    return ImagePickerApiCodec.INSTANCE;
  }

  static setup(binaryMessenger: BinaryMessenger, api: ImagePickerApi) {
    Log.i(TAG, "setup");
    {
      const channel: BasicMessageChannel<ESObject> =
        new BasicMessageChannel<ESObject>(
          binaryMessenger,
          "dev.flutter.pigeon.ImagePickerApi.pickImages",
          ImagePickerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
          onMessage: (message:ESObject, reply:ESObject) => {
            Log.i(TAG, "setup on message : " + message);
            const wrapped:ArrayList<ESObject> = new ArrayList<ESObject>();
            const args: Array<ESObject> = message;
            const sourceArg: SourceSpecification = args[0];
            const optionsArg: ImageSelectionOptions = args[1];
            const generalOptionsArg: GeneralOptions = args[2];
            const resultCallback: Result<ArrayList<string>> =new ResultBuilder((result: ArrayList<string>): void => {
                  wrapped.insert(result.convertToArray(), 0);
                  reply.reply(wrapped.convertToArray());
                },(error: Error): void => {
                  const wrappedError: ArrayList<ESObject> = Messages.wrapError(error);
                  reply.reply(wrappedError.convertToArray());
                })

            api.pickImages(sourceArg, optionsArg, generalOptionsArg, resultCallback);
          }
        })
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      const channel: BasicMessageChannel<ESObject> =
        new BasicMessageChannel<ESObject>(
          binaryMessenger,
          "dev.flutter.pigeon.ImagePickerApi.pickVideos",
          ImagePickerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
          onMessage: (message:ESObject, reply:ESObject) => {
            const wrapped:ArrayList<ESObject> = new ArrayList<ESObject>();
            const args: Array<ESObject> = message;
            const sourceArg: SourceSpecification = args[0];
            const optionsArg: VideoSelectionOptions = args[1];
            const generalOptionsArg: GeneralOptions = args[2];
            const resultCallback: Result<ArrayList<string>> =new ResultBuilder((result: ArrayList<string>): void => {
                  wrapped.insert(result.convertToArray(), 0);
                  reply.reply(wrapped.convertToArray());
                },(error: Error): void => {
                  const wrappedError: ArrayList<ESObject> = Messages.wrapError(error);
                  reply.reply(wrappedError.convertToArray());
                })
            api.pickVideos(sourceArg, optionsArg, generalOptionsArg, resultCallback);
          }
        })
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      const channel: BasicMessageChannel<ESObject> =
        new BasicMessageChannel<ESObject>(
          binaryMessenger,
          "dev.flutter.pigeon.ImagePickerApi.pickMedia",
          ImagePickerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
          onMessage: (message:ESObject, reply:ESObject) => {
            const wrapped:ArrayList<ESObject> = new ArrayList<ESObject>();
            const args: Array<ESObject> = message;
            const optionsArg: MediaSelectionOptions = args[0];
            const generalOptionsArg: GeneralOptions = args[1];
            const resultCallback: Result<ArrayList<string>> = new ResultBuilder( (result: ArrayList<string>): void => {
                  wrapped.insert(result.convertToArray(), 0);
                  reply.reply(wrapped.convertToArray());
                },(error: Error): void => {
                  const wrappedError: ArrayList<ESObject> = Messages.wrapError(error);
                  reply.reply(wrappedError.convertToArray());
                })
            api.pickMedia(optionsArg, generalOptionsArg, resultCallback);
          }
        })
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      const channel: BasicMessageChannel<ESObject> =
        new BasicMessageChannel<ESObject>(
          binaryMessenger,
          "dev.flutter.pigeon.ImagePickerApi.retrieveLostResults",
          ImagePickerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
          onMessage: async (message:ESObject, reply:ESObject) => {
            let wrapped:ArrayList<ESObject> = new ArrayList<ESObject>();
            try {
              const output: CacheRetrievalResult = await api.retrieveLostResults().then((result) => {
                return result;
              });
              wrapped.insert(output, 0);
            } catch (err) {
              const wrappedError: ArrayList<ESObject> = Messages.wrapError(err);
              wrapped = wrappedError;
            }
            reply.reply(wrapped.convertToArray());
          }
        });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
class ResultBuilder{
  success : (result: ArrayList<string>)=>void
  error: (error: Error) =>void

  constructor(success:ESObject , error:ESObject) {
    this.success = success
    this.error = error
  }
}