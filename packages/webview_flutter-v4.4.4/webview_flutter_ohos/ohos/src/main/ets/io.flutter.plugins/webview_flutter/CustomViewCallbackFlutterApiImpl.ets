// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.
// Based on CustomViewCallbackFlutterApiImpl.java originally written by
// Copyright (C) 2023 Maurice Parrish <10687576+bparrishMines@users.noreply.github.com>

import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { CustomViewCallbackFlutterApi, Reply } from './GeneratedOhosWebView';
import { InstanceManager } from './InstanceManager';

export class CustomViewCallbackFlutterApiImpl {

  private binaryMessenger: BinaryMessenger;

  private instanceManager: InstanceManager;

  private api: CustomViewCallbackFlutterApi;

  constructor(binaryMessenger: BinaryMessenger, instanceManager: InstanceManager) {
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
    this.api = new CustomViewCallbackFlutterApi(binaryMessenger);
  }

  create(instance: CustomViewCallback, callback: Reply<void>): void {
    if (!this.instanceManager.containsInstance(instance)) {
      this.api.create(this.instanceManager.addHostCreatedInstance(instance), callback);
    }
  }
}

export interface CustomViewCallback {
  onCustomViewHidden() : void;
}
