// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraDeviceWrapper.java originally written by
// Copyright 2013 The Flutter Authors.

import { List } from '@kit.ArkTS';
import { camera } from '@kit.CameraKit';

export interface CameraDeviceWrapper {

  createCaptureRequest(templateType: number): void;

  // createCaptureSession(config: SessionConfiguration): void;

  createCaptureSession(): void;

  close(): void;
}