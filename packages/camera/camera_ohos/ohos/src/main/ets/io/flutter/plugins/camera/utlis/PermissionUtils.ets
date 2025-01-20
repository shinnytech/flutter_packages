// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.

import abilityAccessCtrl, { PermissionRequestResult } from '@ohos.abilityAccessCtrl';
import { Permissions } from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import Logger from './Logger';
import common from '@ohos.app.ability.common';
import { GlobalContext } from '../utlis/GlobalContext'

const TAG: string = '[Permission]';

const PERMISSIONS: Array<Permissions> = [
  'ohos.permission.CAMERA',
  'ohos.permission.MEDIA_LOCATION',
  'ohos.permission.MICROPHONE',
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA'
];

export default async function grantPermission(): Promise<boolean> {
  try {
    // 获取应用程序的accessTokenID
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
      );
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    let tokenId = appInfo.accessTokenId;

    let atManager = abilityAccessCtrl.createAtManager();
    let pems: Array<Permissions> = [];

    for (let i = 0; i < PERMISSIONS.length; i++) {
      let state = await atManager.checkAccessToken(tokenId, PERMISSIONS[i]);
      Logger.info(TAG, `grantPermission  checkAccessToken ${PERMISSIONS[i]} + : ${JSON.stringify(state)}`);
      if (state !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        pems.push(PERMISSIONS[i]);
      }
    }
    if (pems.length > 0) {
      Logger.info(TAG, 'grantPermission  requestPermissionsFromUser :' + JSON.stringify(pems));
      let ctx: common.UIAbilityContext = GlobalContext.getContext()
        .getValue('cameraContext') as common.UIAbilityContext;
      let result: PermissionRequestResult = await atManager.requestPermissionsFromUser(ctx, pems);

      let grantStatus: Array<number> = result.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        Logger.info(TAG, `grantPermission  requestPermissionsFromUser ${result.permissions[i]} + : ${grantStatus[i]}`);

        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能
          console.log(TAG + 'grantPermission  fail ');
          return false;
        }
      }
    }
    // 授权成功
    Logger.info(TAG, 'grantPermission  success ');
    return true;
  } catch (e) {
    Logger.info(TAG, 'grantPermission  fail ');
    return false;
  }
}
