// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.
// Based on AuthenticationHelper.java originally written by
// Copyright (C) 2022 BeMacized <info@bemacized.net>

import userAuth from '@ohos.userIAM.userAuth';
import common from '@ohos.app.ability.common';
import {
  AbilityPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityPluginBinding';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import { MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { AuthCallback } from './LocalAuthPlugin';

/**
 * Authenticates the user with biometrics and sends corresponding response back to Flutter.
 *
 * <p>One instance per call is generated to ensure readable separation of executable paths across
 * method calls.
 */

const TAG = "AuthenticationHelper";

export class AuthenticationHelper {
  private binding: AbilityPluginBinding | null = null;
  private authCallback: userAuth.IAuthCallback | null = null;
  private authParam : userAuth.AuthParam = {
    challenge: new Uint8Array([49, 49, 49, 49, 49, 49]),
    authType: [
      userAuth.UserAuthType.PIN,
      userAuth.UserAuthType.FINGERPRINT
    ],
    authTrustLevel: userAuth.AuthTrustLevel.ATL1,
  };
  private widgetParam :userAuth.WidgetParam = {
    title: '请输入锁屏密码',
  }

  private userAuthInstance: userAuth.UserAuthInstance | null = null;

  constructor(abilityPluginBinding: AbilityPluginBinding | null,
              call: MethodCall,
              allowCredentials: boolean) {
    this.binding = abilityPluginBinding;
    if (allowCredentials) {
      this.authParam = {
        challenge: new Uint8Array([49, 49, 49, 49, 49, 49]),
        authType: [],
        authTrustLevel: userAuth.AuthTrustLevel.ATL1,
      };
      const argAuthType:string = call.argument("authType")
      switch (argAuthType) {
        case 'FACE':
          this.authParam.authType.push(userAuth.UserAuthType.FACE);
          break;
        case 'FINGERPRINT':
          this.authParam.authType.push(userAuth.UserAuthType.FINGERPRINT);
          break;
        case 'PIN':
          this.authParam.authType.push(userAuth.UserAuthType.PIN);
          break;
        default:
          this.authParam.authType = [
            userAuth.UserAuthType.FINGERPRINT,
            userAuth.UserAuthType.FACE,
            userAuth.UserAuthType.PIN
          ];
          break;
      }
      this.widgetParam = {
        title: call.argument("localizedReason"),
      }
    }
    this.userAuthInstance = userAuth.getUserAuthInstance(this.authParam, this.widgetParam);
    Log.i(TAG, 'get userAuth instance success');
  }

  getContext(): common.UIAbilityContext | undefined {
    return this.binding?.getAbility().context;
  }

  /** Start the biometric listener. */
  authenticate(methodResult: MethodResult): void {
    try {
      this.authCallback = new AuthCallback(methodResult, true);
      let that = this.authCallback;
      this.userAuthInstance?.on('result', {
        onResult(result) {
          that.onResult(result);
        }
      });

      this.userAuthInstance?.start();
      Log.i(TAG, 'auth start success');
    } catch (error) {
      Log.e(TAG, 'auth catch error: ' + JSON.stringify(error));
    }
  }

  /** Cancels the biometric authentication. */
  stopAuthentication(): void {
    try {
      this.userAuthInstance?.cancel();
      Log.i(TAG, 'auth cancel success');
    } catch (error) {
      Log.e(TAG, 'auth catch error: ' + JSON.stringify(error));
    }
  }
}