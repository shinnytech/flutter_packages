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

import picker from '@ohos.file.picker';
import common from '@ohos.app.ability.common';

const CREATE_FILE_NAME_LENGTH_LIMIT = 256;
const ARGS_ZERO = 0;
const ARGS_ONE = 1;
const ARGS_TWO = 2;

const PhotoViewMIMETypes = {
  IMAGE_TYPE: 'image/*',
  VIDEO_TYPE: 'video/*',
  IMAGE_VIDEO_TYPE: '*/*',
  INVALID_TYPE: ''
}

const PHOTO_VIEW_MIME_TYPE_MAP = new Map([
  [PhotoViewMIMETypes.IMAGE_TYPE, 'FILTER_MEDIA_TYPE_IMAGE'],
  [PhotoViewMIMETypes.VIDEO_TYPE, 'FILTER_MEDIA_TYPE_VIDEO'],
  [PhotoViewMIMETypes.IMAGE_VIDEO_TYPE, 'FILTER_MEDIA_TYPE_ALL'],
]);

export async function photoPickerSelect(option: picker.PhotoSelectOptions, context: common.UIAbilityContext) {
  let config = {
    action: 'ohos.want.action.photoPicker',
    type: 'multipleselect',
    parameters: {
      uri: 'multipleselect',
      maxSelectCount: 5,
      filterMediaType: '*/*'
    },
  }
  if (option.maxSelectNumber > 0) {
    let select = (option.maxSelectNumber === 1) ? 'singleselect' : 'multipleselect';
    config.type = select;
    config.parameters.uri = select;
    config.parameters.maxSelectCount = option.maxSelectNumber;
  }
  if (option.MIMEType.length > 0 && PHOTO_VIEW_MIME_TYPE_MAP.has(option.MIMEType)) {
    config.parameters.filterMediaType = PHOTO_VIEW_MIME_TYPE_MAP.get(option.MIMEType);
  }

  try {
    let result = await context.startAbilityForResult(config, {displayId: 1});
    console.log('[picker] result: ' + JSON.stringify(result));
    let uris = result.want.parameters['select-item-list'];
    let isOrigin = result.want.parameters['isOriginal'];
    let selectResult = new picker.PhotoSelectResult();
    if (result.resultCode === -1) {
      result.resultCode = 0;
      uris = [];
      selectResult = null;
    } else {
      selectResult.photoUris = uris as Array<string>;
      selectResult.isOriginalPhoto = isOrigin as boolean;
    }

    return new Promise((resolve, reject) => {
      if (result.resultCode === 0) {
        resolve(selectResult);
      } else {
        console.log('[picker] err: ' + result.resultCode);
        reject(result.resultCode);
      }
    })
  } catch (error) {
    console.log('[picker] error: ' + error);
  }
  return undefined;
}

export async function documentPickerSelect(option: picker.DocumentSelectOptions, context: common.UIAbilityContext) {
  let config = {
    action: 'ohos.want.action.OPEN_FILE',
    parameters: {
      startMode: 'choose',
    }
  }

  try {
    let result = await context.startAbilityForResult(config, {displayId: 1});
    let select_item_list = result.want.parameters.select_item_list;
    let uris = select_item_list.valueOf();

    return new Promise((resolve, reject) => {
      if (result.resultCode === 0) {
        resolve(uris);
      } else {
        console.error('[picker] err: ' + result.resultCode +  "message" + result.want.parameters.message);
        reject(result.resultCode);
      }
    })
  } catch (err) {
    console.error(`Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
  }
  return undefined;
}
