// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraPlugin.java originally written by
// Copyright 2013 The Flutter Authors.

import {
  AbilityAware,
  AbilityPluginBinding,
  BinaryMessenger,
  JSONMessageCodec,
  JSONMethodCodec,
  TextureRegistry
} from '@ohos/flutter_ohos';
import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MethodChannel, { MethodCallHandler } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import { MethodCallHandlerImpl } from './MethodCallHandlerImpl';
import PlatformViewFactory from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformViewFactory';
import common from '@ohos.app.ability.common';
import "@ohos/flutter_ohos/src/main/ets/component/FlutterComponent"
import { CameraPermissions } from './CameraPermissions';

export default class CameraPlugin implements FlutterPlugin, AbilityAware {
  private TAG: string = 'CameraPlugin';
  private flutterPluginBinding: FlutterPluginBinding | null = null;
  private methodCallHandler: MethodCallHandlerImpl | null = null;
  private textureRegistry : TextureRegistry  | null = null



  constructor() {
  }

  getUniqueClassName(): string {
    return this.TAG;
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.flutterPluginBinding = binding;
    this.textureRegistry =  binding.getTextureRegistry();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.flutterPluginBinding = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    if (this.flutterPluginBinding != null) {

      this.methodCallHandler = new MethodCallHandlerImpl(binding.getAbility(),
        this.flutterPluginBinding.getBinaryMessenger(), new CameraPermissions(), this.flutterPluginBinding.getTextureRegistry());
    }
  }

  onDetachedFromAbility(): void {
    if (this.methodCallHandler != null) {
      this.methodCallHandler.stopListening();
      this.methodCallHandler = null;
    }
  }


}