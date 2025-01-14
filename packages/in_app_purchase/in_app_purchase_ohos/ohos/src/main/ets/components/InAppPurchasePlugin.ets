// Copyright (c) 2024 SwanLink (Jiangsu) Technology Development Co., LTD.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.
// Based on InAppPurchasePlugin.java originally written by
// Copyright (C) 2021 Maurits van Beusekom <maurits@baseflow.com>

import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  BinaryMessenger,
  Log,
  MethodChannel,
} from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import { MethodCallHandlerImpl } from './MethodCallHandlerImpl';

const TAG = "InAppPurchasePlugin"

export class InAppPurchasePlugin implements FlutterPlugin, AbilityAware {
  private methodChannel: MethodChannel | null = null
  private methodCallHandler: MethodCallHandlerImpl | null = null
  private context: common.UIAbilityContext | null = null

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.setUpMethodChannel(binding.getBinaryMessenger(), binding.getApplicationContext());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.teardownMethodChannel();
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.context = binding.getAbility().context
    this.methodCallHandler?.setContext(this.context)
  }

  onDetachedFromAbility(): void {
    this.methodCallHandler?.setContext(null)
  }

  getUniqueClassName(): string {
    return TAG
  }

  setUpMethodChannel(messenger: BinaryMessenger, context: common.Context) {
    this.methodChannel = new MethodChannel(messenger, "plugins.flutter.io/in_app_purchase");
    this.methodCallHandler =
      new MethodCallHandlerImpl(context, this.methodChannel);
    this.methodChannel.setMethodCallHandler(this.methodCallHandler);
  }

  teardownMethodChannel() {
    this.methodChannel?.setMethodCallHandler(null);
    this.methodChannel = null;
    this.methodCallHandler = null;
    this.context = null;
  }
}
