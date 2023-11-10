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

import { ByteBuffer } from '@ohos/flutter_embedding/src/main/ets/util/ByteBuffer';
import StandardMessageCodec from '@ohos/flutter_embedding/src/main/ets/plugin/common/StandardMessageCodec';
import Log from '@ohos/flutter_embedding/src/main/ets/util/Log';

const TAG = "GeneratedFileSelectorApi";

class FlutterError extends Error {
  /** The error code. */
  public code: string;

  /** The error details. Must be a datatype supported by the api codec. */
  public details: any;

  constructor(code: string, message: string, details: any) {
    super(message);
    this.code = code;
    this.details = details;
  }
}

export function wrapError(exception: Error): Array<any> {
  let errorList = new Array<any>();
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

export class FileResponse {
  private path: string;

  public getPath(): string {
    return this.path;
  }

  public setPath(setterArg: string): void {
    if (setterArg == null) {
      throw new Error('Nonnull field \'path\' is null.');
    }
    this.path = setterArg;
  }

  private mimeType: string;

  public getMimeType(): string {
    return this.mimeType;
  }

  public setMimeType(setterArg: string): void {
    this.mimeType = setterArg;
  }

  private name: string;

  public getName(): string {
    return this.name;
  }

  public setName(setterArg: string): void {
    this.name = setterArg;
  }

  private size: number;

  public getSize(): number {
    return this.size;
  }

  public setSize(setterArg: number): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"size\" is null.");
    }
    this.size = setterArg;
  }

  private bytes: Uint8Array;

  public getBytes(): Uint8Array {
    return this.bytes;
  }

  public setBytes(setterArg: Uint8Array): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"bytes\" is null.");
    }
    this.bytes = setterArg;
  }


  constructor(path: string, mimeType: string, name: string, size: number, bytes: Uint8Array) {
    this.path = path;
    this.mimeType = mimeType;
    this.name = name;
    this.size = size;
    this.bytes = bytes;
  }

  toList(): Array<any> {
    let toListResult = new Array<any>();
    toListResult.push(this.path);
    toListResult.push(this.mimeType);
    toListResult.push(this.name);
    toListResult.push(this.size);
    toListResult.push(this.bytes);
    return toListResult;
  }

  static fromList(list: Array<any>): FileResponse {
    let path = list[0];
    let mimeType = list[1];
    let name = list[2];
    let size = list[3];
    let bytes = list[4];
    let response = new FileResponse(path, mimeType, name, size, bytes);
    return response;
  }
}

export class FileTypes {
  mimeTypes: Array<string>;

  getMimeTypes(): Array<string>  {
    return this.mimeTypes;
  }

  setMimeTypes(setterArg: Array<string>): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"mimeTypes\" is null.");
    }
    this.mimeTypes = setterArg;
  }

  extensions: Array<string>;

  getExtensions(): Array<string> {
    return this.extensions;
  }

  setExtensions(setterArg: Array<string>): void {
    if (setterArg == null) {
      throw new Error("Nonnull field \"extensions\" is null.");
    }
    this.extensions = setterArg;
  }

  /** Constructor is non-public to enforce null safety; use Builder. */
  FileTypes() {}

  toList(): Array<any> {
    let toListResult = new Array<any>();
    toListResult.push(this.mimeTypes);
    toListResult.push(this.extensions);
    return toListResult;
  }

  static fromList(list: Array<any>): FileTypes {
    let pigeonResult = new FileTypes();
    let mimeTypes = list[0];
    pigeonResult.setMimeTypes(mimeTypes as Array<string>);
    let extensions = list[1];
    pigeonResult.setExtensions(extensions as Array<string>);
    Log.d(TAG, 'readValueOfType fromList  mimeTypes:' + mimeTypes + '  extensions:' + pigeonResult.getExtensions())
    return pigeonResult;
  }
}


export interface Result<T> {
  success(result: T): void;
  error(error: Error): void;
}

export class FileSelectorApiCodec extends StandardMessageCodec {
    public static INSTANCE = new FileSelectorApiCodec();

    private FileSelectorApiCodec() {}

    readValueOfType(type: number, buffer: ByteBuffer): any {
      switch (type) {
        case 128:
          var res0 =  FileResponse.fromList(super.readValue(buffer) as Array<any>);
          return res0;
        case -127:
          let vur = super.readValue(buffer)
          var res1 =  FileTypes.fromList(vur as Array<any>);
          return res1;
        default:
          var res2 = super.readValueOfType(type, buffer);
          return res2;
      }
    }

    writeValue(stream: ByteBuffer, value: any): any {
      if (value instanceof FileResponse) {
        stream.writeInt8(128);
        return this.writeValue(stream, (value as FileResponse).toList());
      } else if (value instanceof FileTypes) {
        stream.writeInt8(-127);
        return this.writeValue(stream, (value as FileTypes).toList());
      } else {
        return super.writeValue(stream, value);
      }
      return stream
    }
  }
