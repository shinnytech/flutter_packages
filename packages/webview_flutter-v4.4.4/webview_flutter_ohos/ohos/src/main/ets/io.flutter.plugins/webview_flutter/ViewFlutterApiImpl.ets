// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.
// Based on ViewFlutterApiImpl.java originally written by
// Copyright (C) 2021 Maurice Parrish <bmparr@google.com>

import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { DVModel } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView';
import { Reply, ViewFlutterApi } from './GeneratedOhosWebView';
import { InstanceManager } from './InstanceManager';

export class ViewFlutterApiImpl {

  private binaryMessenger: BinaryMessenger;

  private instanceManager: InstanceManager;

  private api: ViewFlutterApi;

  constructor(binaryMessenger: BinaryMessenger, instanceManager: InstanceManager) {
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
    this.api = new ViewFlutterApi(binaryMessenger);
  }

  create(instance: DVModel, callback: Reply<void>): void {
    if (!this.instanceManager.containsInstance(instance)) {
      this.api.create(this.instanceManager.addHostCreatedInstance(instance), callback);
    }
  }
}
