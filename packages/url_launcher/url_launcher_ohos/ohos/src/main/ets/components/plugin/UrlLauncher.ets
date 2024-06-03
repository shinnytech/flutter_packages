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
import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';
import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';
import Want from '@ohos.app.ability.Want';
import wantConstant from '@ohos.app.ability.wantConstant';
import fileuri from '@ohos.file.fileuri';
import { FlutterError, UrlLauncherApi, UrlLauncherApiCodec, WebViewOptions, wrapError } from './Messages';
import common from '@ohos.app.ability.common';
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import call from '@ohos.telephony.call';
import i18n from '@ohos.i18n';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';

const TAG = 'UrlLauncher'

class SendMessageParams {
  telephone: string = '';
  telephoneFormat: string = '';
  contactName: string = '';
}

export class UrlLauncher implements UrlLauncherApi {
  static LAUNCH_TYPE_TEL: string = 'tel';
  static LAUNCH_TYPE_WEB: string = 'http';
  static LAUNCH_TYPE_MAILTO: string = 'mailto';
  static LAUNCH_TYPE_SMS: string = 'sms';
  static LAUNCH_TYPE_FILE: string = 'file';

  static MMS_BUNDLE_NAME = "com.ohos.mms";
  static MMS_ABILITY_NAME = "com.ohos.mms.MainAbility";
  static MMS_ENTITIES = 'entity.system.home';

  private context: common.UIAbilityContext;

  constructor(ctx: common.UIAbilityContext) {
    this.context = ctx;
  }

  getPermission() {
    let array: Array<Permissions> = [
      "ohos.permission.READ_MEDIA",
      "ohos.permission.WRITE_MEDIA",
      "ohos.permission.MEDIA_LOCATION",
      "ohos.permission.GET_BUNDLE_INFO",
      "ohos.permission.DISTRIBUTED_DATASYNC",
    ];

    let atManager = abilityAccessCtrl.createAtManager();
    //requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(this.context, array).then((data) => {
      Log.d(TAG, "data type:" + typeof (data));
      Log.d(TAG, "data:" + data);
      Log.d(TAG, "data permissions:" + data.permissions);
      Log.d(TAG, "data result:" + data.authResults);
    }, (err: Error) => {
      Log.e(TAG,'Failed to start ability', JSON.stringify(err));
    });
  }

  canLaunchUrl(url: string): boolean {
    return true;
  }

  launchUrl(url: string, headers: Map<string, string>): boolean {
    this.ensureContext();
    let encodedUri = encodeURI(url);
    Log.d(TAG, 'launchUrl. url:' + url + '  eurl:' + encodedUri);
    if (encodedUri.startsWith(UrlLauncher.LAUNCH_TYPE_TEL)) {
      return this.launchTel(url);
    } else if (encodedUri.startsWith(UrlLauncher.LAUNCH_TYPE_WEB)) {
      return this.launchWeb(url, headers);
    } else if (encodedUri.startsWith(UrlLauncher.LAUNCH_TYPE_MAILTO)) {
      return this.launchMail(url);
    } else if (encodedUri.startsWith(UrlLauncher.LAUNCH_TYPE_SMS)) {
      return this.launchSms(url);
    } else if (encodedUri.startsWith(UrlLauncher.LAUNCH_TYPE_FILE)) {
      return this.launchFile(url);
    } else {
      Log.w(TAG, 'launch type unsurppoted. url:' + url);
      return false;
    }
  }

  format(number: string) {
    let regex: RegExp = new RegExp('/[\s]/g');
    let phoneNumber = number.replace(regex, '');
    let countryId = i18n.getSystemRegion();
    let phoneNumberFormat= new i18n.PhoneNumberFormat(countryId);
    let isNumberValid:boolean = phoneNumberFormat.isValidNumber(phoneNumber);
    let formatNumber = isNumberValid ? phoneNumberFormat.format(phoneNumber) : phoneNumber;
    return formatNumber;
  }

  launchSms(url: string): boolean {
    let phoneNum = this.parseUrl(url, UrlLauncher.LAUNCH_TYPE_SMS + ':');
    let formatNum = this.format(phoneNum);

    let msgParam = new SendMessageParams();
    msgParam.telephone = phoneNum;
    msgParam.telephoneFormat = formatNum;

    let params = new Array<SendMessageParams>();
    params.push(msgParam);

    let actionData: ESObject = {};
    actionData.contactObjects = JSON.stringify(params);
    actionData.pageFlag = 'conversation';
    let str : Want = {
      'bundleName': UrlLauncher.MMS_BUNDLE_NAME,
      'abilityName': UrlLauncher.MMS_ABILITY_NAME,
      'parameters': actionData,
      'entities': [
        UrlLauncher.MMS_ENTITIES,
      ]
    };
    Log.i(TAG, 'jumpToMms want: %s', JSON.stringify(params));
    this.context.startAbility(str).then(() => {
      Log.i(TAG, 'jumpToMms success.');
    }).catch((error: ESObject) => {
      Log.e(TAG, 'jumpToMms failed: %s', JSON.stringify(error));
    })
    return true
  }

  launchTel(url: string): boolean {
    Log.d(TAG, 'launchTel:' + url);
    let phoneNum = this.parseUrl(url, UrlLauncher.LAUNCH_TYPE_TEL + ':');
    call.makeCall(phoneNum).then(() => {
      Log.e(TAG, `launchTel success`);
    }).catch((err: ESObject) => {
      Log.e(TAG, `launchTel failed,  error: ${JSON.stringify(err)}`);
    })
    return true;
  }

  // 只支持沙箱路径
  launchFile(url: string): boolean {
    let fileUrl = this.parseUrl(url, UrlLauncher.LAUNCH_TYPE_FILE + '://');
    let filePath = this.context.filesDir + fileUrl;
    // 将沙箱路径转换为uri
    let uriFromPath = fileuri.getUriFromPath(filePath);
    Log.d(TAG, 'launchFile:' + fileUrl + '  uriFromPath:' + uriFromPath);
    let want: Want = {
      flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      // 配置分享应用的隐式拉起规则
      action: 'ohos.want.action.viewData',
      uri: uriFromPath,
    }
    this.context.startAbility(want)
      .then(() => {
        Log.i(TAG, 'Invoke getCurrentBundleStats succeeded.');
      })
      .catch((err: ESObject) => {
        Log.e(TAG, `Invoke startAbility failed, code is ${err.code}, message is ${err.message}`);
      });
    return true;
  }

  launchWeb(url: string, headers: Map<string, string>): boolean {
    Log.d(TAG, 'launchWeb url:' + url);
    let params: Record<string, Object>  = {};

    for (let val of headers) {
      params[val[0]] = val[1]
    }

    let want: Want = {
      uri: url,
      parameters: params,
      entities: ['entity.system.browsable'],
      action: 'ohos.want.action.viewData',
    }
    try {
      this.context.startAbility(want)
    } catch (e) {
      Log.e(TAG, 'launchWeb failed. err:' + JSON.stringify(e))
      return false
    }
    return true;
  }

  launchMail(url: string): boolean {
    let mailAddress = this.parseUrl(url, UrlLauncher.LAUNCH_TYPE_MAILTO + ':');
    let want: Want = {
      abilityName: 'PhoneAbility',
      bundleName: 'com.huawei.hmos.email',
    }
    try {
      this.context.startAbility(want)
    } catch (e) {
      Log.e(TAG, 'launchMail failed. err:' + JSON.stringify(e))
      return false
    }
    return true;
  }

  parseUrl(url: string, prefix: string): string {
    if (url == null || url == undefined) {
      return ''
    }
    return url.replace(prefix, '');
  }

  private ensureContext(): void {
    if (this.context == null) {
      throw new FlutterError(
        "NO_ACTIVITY", "Launching a URL requires a foreground activity.", null);
    }
  }

  openUrlInWebView(url: string, options: WebViewOptions): boolean {
    try {
      this.context?.startAbility({
        action: 'ohos.want.action.viewData',
        entities: ['entity.system.browsable'],
        uri: url,
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  closeWebView(): boolean {
    throw new Error('Method not implemented.');
  }

  getCodec(): MessageCodec<ESObject> {
    return UrlLauncherApiCodec.INSTANCE;
  }

  setup(binaryMessenger: BinaryMessenger, api: UrlLauncherApi) {
    {
      if (binaryMessenger == null) {
        return;
      }
      let channel: BasicMessageChannel<ESObject> = new BasicMessageChannel<ESObject>(
        binaryMessenger, "dev.flutter.pigeon.UrlLauncherApi.canLaunchUrl", this.getCodec());
      Log.d(TAG, 'setup launchUrl')
      if (api != null && api != undefined) {
        Log.d(TAG, 'setMessageHandler')
        channel.setMessageHandler({
          onMessage(msg: ESObject, reply: Reply<ESObject>): void {
            let wrapped = new Array<Object>();
            let args = msg as Array<Object>;
            let urlArg = args[0] as string;
            try {
              let output = api.canLaunchUrl(urlArg);
              wrapped.push(output);
            } catch (err) {
              let errs = wrapError(err);
              wrapped = errs;
            }
            reply.reply(wrapped)
          }
        });
      } else {
        channel.setMessageHandler(null)
      }
    }
    {
      let channel = new BasicMessageChannel<Object>(
        binaryMessenger, "dev.flutter.pigeon.UrlLauncherApi.launchUrl", this.getCodec());
      Log.d(TAG, 'setup launchUrl')
      if (api != null && api != undefined) {
        Log.d(TAG, 'setMessageHandler')
        channel.setMessageHandler({
          onMessage(msg: ESObject, reply: Reply<ESObject>): void {
            let wrapped = new Array<Object>();
            let args = msg as Array<Object>;
            let urlArg = args[0] as string;
            let headersArg = args[1] as Map<string, string>;
            try {
              let output = api.launchUrl(urlArg, headersArg);
              wrapped.push(output);
            } catch (err) {
              let errs = wrapError(err);
              wrapped = errs;
            }
            reply.reply(wrapped)
          }
        });
      } else {
        channel.setMessageHandler(null)
      }
    }
    {
      let channel = new BasicMessageChannel<Object>(
        binaryMessenger, "dev.flutter.pigeon.UrlLauncherApi.openUrlInWebView", this.getCodec());
      Log.d(TAG, 'setup launchUrl')
      if (api != null && api != undefined) {
        Log.d(TAG, 'setMessageHandler')
        channel.setMessageHandler({
          onMessage(msg: ESObject, reply: Reply<ESObject>): void {
            let wrapped = new Array<Object>();
            let args = msg as Array<Object>;
            let urlArg = args[0] as string;
            let optionsArg = args[1] as WebViewOptions;
            try {
              let output = api.openUrlInWebView(urlArg, optionsArg);
              wrapped.push(output);
            } catch (err) {
              let errs = wrapError(err);
              wrapped = errs;
            }
            reply.reply(wrapped)
          }
        });
      } else {
        channel.setMessageHandler(null)
      }
    }
    {
      let channel = new BasicMessageChannel<Object>(
        binaryMessenger, "dev.flutter.pigeon.UrlLauncherApi.closeWebView", this.getCodec());
      Log.d(TAG, 'setup launchUrl')
      if (api != null && api != undefined) {
        Log.d(TAG, 'setMessageHandler')
        channel.setMessageHandler({
          onMessage(msg: ESObject, reply: Reply<ESObject>): void {
            let wrapped = new Array<Object>();
            try {
              let output = api.closeWebView();
              wrapped.push(output);
            } catch (err) {
              let errs = wrapError(err);
              wrapped = errs;
            }
            reply.reply(wrapped)
          }
        });
      } else {
        channel.setMessageHandler(null)
      }
    }
  }
}