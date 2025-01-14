// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.
// Based on FlutterAssetManager.java originally written by
// Copyright (C) 2021 Maurits van Beusekom <maurits@baseflow.com>

import resourceManager from '@ohos.resourceManager';
import { FlutterAssets } from "@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin"

export abstract class FlutterAssetManager {
  private resourceManager: resourceManager.ResourceManager;

  constructor(resourceManager: resourceManager.ResourceManager) {
    this.resourceManager = resourceManager;
  }

  abstract getAssetFilePathByName(name: string)

  async list(path: string): Promise<string[]> {
    return await this.resourceManager.getRawFileList(path);
  }
}

export class PluginBindingFlutterAssetManager extends FlutterAssetManager {
  flutterAssets: FlutterAssets;

  constructor(resourceManager: resourceManager.ResourceManager, flutterAssets: FlutterAssets) {
    super(resourceManager);
    this.flutterAssets = flutterAssets;
  }

  getAssetFilePathByName(name: string): string {
    return this.flutterAssets.getAssetFilePathByName(name);
  }
}