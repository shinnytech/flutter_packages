// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.
// Based on CustomViewCallbackHostApiImpl.java originally written by
// Copyright (C) 2023 Maurice Parrish <10687576+bparrishMines@users.noreply.github.com>

import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { CustomViewCallback } from './CustomViewCallbackFlutterApiImpl';
import { CustomViewCallbackHostApi } from './GeneratedOhosWebView';
import { InstanceManager } from './InstanceManager';

export class CustomViewCallbackHostApiImpl extends CustomViewCallbackHostApi {

  private binaryMessenger:BinaryMessenger ;

  private instanceManager:InstanceManager;

  constructor(binaryMessenger:BinaryMessenger, instanceManager:InstanceManager) {
    super()
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
  }


  onCustomViewHidden(identifier: number): void {
    this.getCustomViewCallbackInstance(identifier).onCustomViewHidden()
  }

  private getCustomViewCallbackInstance(identifier: number): CustomViewCallback{
    return this.instanceManager.getInstance(identifier)
  }
}
