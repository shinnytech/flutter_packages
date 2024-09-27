/*
* Copyright (c) 2024 Huawei Technologies Co., Ltd.
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
import { util } from '@kit.ArkTS';

const centerLineRegex: RegExp = new RegExp('-', 'g');
const underLineRegex: RegExp = new RegExp('_', 'g');
const textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
const base64 = new util.Base64Helper();
const TAG: string = 'JWTUtil';

const BASE64_PAD_MOD = 4;
const BASE64_PAD_INVALID = 1;

export class JWTUtil {
  public static base64Decode(input: string) {
    return textDecoder.decodeWithStream(base64.decodeSync(input));
  }

  private static base64UrlDecode(input: string) {
    input = input
      .replace(centerLineRegex, '+')
      .replace(underLineRegex, '/');

    // Pad out with standard base64 required padding characters
    const pad = input.length % BASE64_PAD_MOD;
    if (pad) {
      if (pad === BASE64_PAD_INVALID) {
        throw new Error('InvalidLengthError: Input base64url string is the wrong length to determine padding');
      }
      input += new Array(5 - pad).join('=');
    }
    return this.base64Decode(input);
  }

  public static decodeJwtObj(data: string) {
    let jwt: string[] = data.split(".");
    let exp: string = "";
    if (jwt.length < 3) {
      return exp;
    }
    try {
      exp = JWTUtil.base64UrlDecode(jwt[1]);
    } catch (err) {
      console.error(TAG, 'decodeJwtObj parse err: ' + JSON.stringify(err));
    }
    return exp;
  }
}