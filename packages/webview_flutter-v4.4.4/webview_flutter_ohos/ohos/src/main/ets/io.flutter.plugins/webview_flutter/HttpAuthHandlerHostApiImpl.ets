// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.
// Based on HttpAuthHandlerHostApiImpl.java originally written by
// Copyright 2013 The Flutter Authors.

import { BinaryMessenger } from '@ohos/flutter_ohos';
import { HttpAuthHandlerHostApi } from './GeneratedOhosWebView';
import { InstanceManager } from './InstanceManager';

export class HttpAuthHandlerHostApiImpl extends HttpAuthHandlerHostApi {

  private binaryMessenger:BinaryMessenger ;

  private instanceManager:InstanceManager;

  constructor(binaryMessenger:BinaryMessenger, instanceManager:InstanceManager) {
    super()
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
  }

  useHttpAuthUsernamePassword(instanceId: number): boolean {
    return this.getHttpAuthHandlerInstance(instanceId).isHttpAuthInfoSaved()
  }

  cancel(instanceId: number): void {
    this.getHttpAuthHandlerInstance(instanceId).cancel()
  }

  proceed(instanceId: number, username: string, password: string): void {
    this.getHttpAuthHandlerInstance(instanceId).confirm(username, password)
  }

  private getHttpAuthHandlerInstance(instanceId: number): HttpAuthHandler{
    return this.instanceManager.getInstance(instanceId)
  }
}