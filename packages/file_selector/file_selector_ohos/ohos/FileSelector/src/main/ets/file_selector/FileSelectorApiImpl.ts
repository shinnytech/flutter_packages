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

import fs from '@ohos.file.fs';
import picker from '@ohos.file.picker';
import Log from '@ohos/flutter_embedding/src/main/ets/util/Log';
import { Result, FileTypes, FileResponse, FileSelectorApiCodec, wrapError } from './GeneratedFileSelectorApi'
import type { BinaryMessenger } from '@ohos/flutter_embedding/src/main/ets/plugin/common/BinaryMessenger';
import type MessageCodec from '@ohos/flutter_embedding/src/main/ets/plugin/common/MessageCodec';
import BasicMessageChannel, { Reply } from '@ohos/flutter_embedding/src/main/ets/plugin/common/BasicMessageChannel';
import type { AbilityPluginBinding } from '@ohos/flutter_embedding/src/main/ets/embedding/engine/plugins/ability/AbilityPluginBinding';
import type common from '@ohos.app.ability.common';
import { photoPickerSelect, documentPickerSelect } from './FIleSelectorUtil'

const TAG = "FileSelectorApiImpl";
const DOCUMENT = "Document";
const TEXT_MIME_TYPE = "text/*";
const PICTURE = "Picture";
const TEXT = "Text";
export class FileSelectorApiImpl {

  binding: AbilityPluginBinding;

  constructor(binding: AbilityPluginBinding) {
    this.binding = binding;
  }

  openFile(initialDirectory: string, allowedTypes: FileTypes, result: Result<FileResponse>): void {
    if (allowedTypes.getMimeTypes().length == 0) {
      allowedTypes.setMimeTypes(tryConvertExtensionsToMimetypes(allowedTypes.getExtensions()));
    }
    Log.d(TAG, 'openFile types:' + allowedTypes.mimeTypes + ' dir:' + initialDirectory)
    for (let type of allowedTypes.getMimeTypes()) {
      Log.d(TAG, 'openFile type:' + type)
      switch (type) {
        case picker.PhotoViewMIMETypes.IMAGE_TYPE:
        case picker.PhotoViewMIMETypes.VIDEO_TYPE:
        case picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE:
          try {
            let PhotoSelectOptions = new picker.PhotoSelectOptions();
            PhotoSelectOptions.MIMEType = type;
            PhotoSelectOptions.maxSelectNumber = 1;
            photoPickerSelect(PhotoSelectOptions, this.getContext()).then((PhotoSelectResult) => {
              console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
              let res = <picker.PhotoSelectResult>(PhotoSelectResult);
              FileSelectorApiImpl.toFileResponse(res.photoUris[0] , type, PICTURE)
                .then((file) => {
                  result.success(file);
              }).catch((err) => {
                  Log.e(TAG, 'PhotoViewPicker.select failed with err: ' + err);
                  result.error(err);
              });
            }).catch((err) => {
              Log.e(TAG, 'PhotoViewPicker.select failed with err: ' + err);
              result.error(new Error("Failed to read file, err: " + err));
            });
          } catch (err) {
            console.error('PhotoViewPicker failed with err: ' + err);
            result.error(new Error("Failed to read file: " + initialDirectory));
          }
          break;
        case DOCUMENT:
          try {
            let documentSelectOptions = new picker.DocumentSelectOptions();
            documentPickerSelect(documentSelectOptions, this.getContext()).then((documentPickerResult) => {
              if (isNaN(Number(documentPickerResult))) {
                let uri = documentPickerResult[0];
                Log.i(TAG,'documentPickerSelect select successfully, documentPicker uri: ' + uri);
                FileSelectorApiImpl.toFileResponse(uri, TEXT_MIME_TYPE, TEXT)
                  .then((file) => {
                    result.success(file);
                  }).catch((err) => {
                  Log.e(TAG, 'documentPickerSelect select failed with err: ' + err);
                  result.error(err);
                });
              } else {
                Log.e(TAG, 'documentPickerSelect select failed with errCode: ' + documentPickerResult);
                result.error(new Error("Failed to select file with errCode: " + documentPickerResult))
              }
            });
          } catch (err) {
            Log.e(TAG, 'documentPickerSelect select failed with err: ' + err);
            result.error(new Error("Failed to read file: " + initialDirectory));
          }
          break;
        default :
          break;
      }
    }
  }

  getContext(): common.UIAbilityContext {
    return this.binding.getAbility().context;
  }

  openFiles(initialDirectory: string, allowedTypes: FileTypes, result: Result<Array<FileResponse>>): void {
    if (allowedTypes.getMimeTypes().length == 0) {
      allowedTypes.setMimeTypes(tryConvertExtensionsToMimetypes(allowedTypes.getExtensions()));
    }
    for (let type of allowedTypes.getMimeTypes()) {
      Log.d(TAG, 'openFiles type:' + type)
      switch (type) {
        case picker.PhotoViewMIMETypes.IMAGE_TYPE:
        case picker.PhotoViewMIMETypes.VIDEO_TYPE:
        case picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE:
          try {
            let PhotoSelectOptions = new picker.PhotoSelectOptions();
            PhotoSelectOptions.MIMEType = type;
            PhotoSelectOptions.maxSelectNumber = 5;
            photoPickerSelect(PhotoSelectOptions, this.getContext()).then((PhotoSelectResult) => {
              Log.i(TAG, 'PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
              let res = <picker.PhotoSelectResult>(PhotoSelectResult);
              FileSelectorApiImpl.toFileListResponse(res.photoUris , type, PICTURE)
                .then((files) => {
                  Log.i(TAG, 'PhotoViewPicker.select successfully, uri: ' + JSON.stringify(PhotoSelectResult));
                  result.success(files);
                }).catch((err) => {
                  Log.e(TAG, 'PhotoViewPicker.select failed with err: ' + err);
                  result.error(err);
              });
            }).catch((err) => {
              Log.e(TAG, 'PhotoViewPicker.select failed with err: ' + err);
              result.error(new Error("Failed to read file, err: " + err));
            });
          } catch (err) {
            Log.e(TAG, 'PhotoViewPicker failed with err: ' + err);
            result.error(new Error("Failed to read file: " + initialDirectory));
          }
          break;
        case DOCUMENT:
          try {
            let documentSelectOptions = new picker.DocumentSelectOptions();
            documentPickerSelect(documentSelectOptions, this.getContext()).then((documentPickerResult) => {
              if (isNaN(Number(documentPickerResult))) {
                let pickerResult = documentPickerResult as Array<string>;
                Log.i(TAG,'documentPickerSelect select successfully, documentPicker uris: ' + pickerResult.toString());
                FileSelectorApiImpl.toFileListResponse(pickerResult, TEXT_MIME_TYPE, TEXT)
                  .then((files) => {
                    result.success(files);
                  }).catch((err) => {
                  Log.e(TAG, 'documentPickerSelect select failed with err: ' + err);
                  result.error(err);
                });
              } else {
                Log.e(TAG, 'documentPickerSelect select failed with errCode: ' + documentPickerResult);
                result.error(new Error("Failed to select file with errCode: " + documentPickerResult))
              }
            });
          } catch (err) {
            Log.e(TAG, 'documentPickerSelect select failed with err: ' + err);
            result.error(new Error("Failed to read file: " + initialDirectory));
          }
          break;
        default :
          break;
      }
    }
  }

  getDirectoryPath(initialDirectory: string, result: Result<string>): void {
    throw new Error('Method not implemented.')
  }

  static getCodec(): MessageCodec<any> {
    return FileSelectorApiCodec.INSTANCE;
  }

  setup(binaryMessenger: BinaryMessenger, abilityPluginBinding: AbilityPluginBinding): void {
    let api = this;
    {
      this.binding = abilityPluginBinding;
      let channel = new BasicMessageChannel<any>(
        binaryMessenger, "dev.flutter.pigeon.FileSelectorApi.openFile", FileSelectorApiImpl.getCodec());
      channel.setMessageHandler({
        onMessage(msg: any, reply: Reply<any>): void {
          Log.d(TAG, 'onMessage reply:' + reply)
          let wrapped = new Array<any>();
          let args = msg as Array<any>;
          let initialDirectoryArg = args[0] as string;
          let allowedTypesArg = args[1] as FileTypes;
          api.openFile(initialDirectoryArg, allowedTypesArg, {
            success: (result: any): void => {
              wrapped.push(result);
              reply.reply(wrapped);
            },

            error: (error: Error): void => {
              let wrappedError = wrapError(error);
              reply.reply(wrappedError);
            }
          })
        }
      });
    }
    {
      this.binding = abilityPluginBinding;
      let channel = new BasicMessageChannel<any>(
        binaryMessenger, "dev.flutter.pigeon.FileSelectorApi.openFiles", FileSelectorApiImpl.getCodec());
      channel.setMessageHandler({
        onMessage(msg: any, reply: Reply<any>): void {
          Log.d(TAG, 'onMessage reply:' + reply)
          let wrapped = new Array<any>();
          let args = msg as Array<any>;
          let initialDirectoryArg = args[0] as string;
          let allowedTypesArg = args[1] as FileTypes;
          api.openFiles(initialDirectoryArg, allowedTypesArg, {
            success: (result: any): void => {
              wrapped.push(result);
              reply.reply(wrapped);
            },

            error: (error: Error): void => {
              let wrappedError = wrapError(error);
              reply.reply(wrappedError);
            }
          })
        }
      });
    }
  }

  static async toFileResponse(uri: string, type: string, name: string): Promise<FileResponse> {
    let file = fs.openSync(uri);
    let stream = fs.fdopenStreamSync(file.fd, "r");
    let stat = fs.statSync(file.fd);
    let size = stat.size;
    let buffer = new ArrayBuffer(size);
    stream.readSync(buffer, {offset: 0, length: size});
    let byteArray = new Uint8Array(buffer);
    let response = new FileResponse(uri, type, name, size, byteArray);
    fs.closeSync(file.fd);
    return new Promise((resolve) => {
      resolve(response);
    })
  }

  static async toFileListResponse(uris: string[], type: string, name: string): Promise<Array<FileResponse>> {
    let files = new Array<FileResponse>();
    for (var i = 0; i < uris.length; i++) {
      let file = fs.openSync(uris[i]);
      let stream = fs.fdopenStreamSync(file.fd, "r");
      let stat = fs.statSync(file.fd);
      let size = stat.size;
      let buffer = new ArrayBuffer(size);
      stream.readSync(buffer, {offset: 0, length: size});
      let byteArray = new Uint8Array(buffer);
      let response = new FileResponse(uris[i], type, name, size, byteArray);
      fs.closeSync(file.fd);
      files.push(response)
    }

    return new Promise((resolve, reject) => {
      if (files.length > 0) {
        resolve(files);
      } else {
        reject(new Error('Read file list failed'))
      }
    })
  }
}

function tryConvertExtensionsToMimetypes(list: Array<string>): Array<string> {
  if (list == undefined || list.length == 0) {
    Log.w(TAG, 'list is empty')
    return null;
  }
  let mimeTypes = new Array<string>()
  for (let str of list) {
    switch (str) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        if (mimeTypes.indexOf(picker.PhotoViewMIMETypes.IMAGE_TYPE) == -1) {
          mimeTypes.push(picker.PhotoViewMIMETypes.IMAGE_TYPE)
        }
        break;
      case 'txt':
      case 'json':
      default :
        if (mimeTypes.indexOf(DOCUMENT) == -1) {
          mimeTypes.push(DOCUMENT);
        }
        break;
    }
  }
  return mimeTypes;
}