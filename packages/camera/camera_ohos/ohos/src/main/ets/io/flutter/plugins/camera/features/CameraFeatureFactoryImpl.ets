// Copyright (c) 2024 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on CameraFeatureFactoryImpl.java originally written by
// Copyright 2013 The Flutter Authors.

import Ability from '@ohos.app.ability.Ability';
import { CameraProperties } from '../CameraProperties';
import { AutoFocusFeature } from './autofocus/AutoFocusFeature';
import { CameraFeatureFactory } from './CameraFeatureFactory';
import { ExposureLockFeature } from './exposurelock/ExposureLockFeature';
import { ExposureOffsetFeature } from './exposureoffset/ExposureOffsetFeature';
import { FlashFeature } from './flash/FlashFeature';
import { FocusPointFeature } from './focuspoint/FocusPointFeature';
import { FpsRangeFeature } from './fpsrange/FpsRangeFeature';
import { ResolutionFeature } from './resolution/ResolutionFeature';
import { ResolutionPreset } from './resolution/ResolutionPreset';
import { SensorOrientationFeature } from './sensororientation/SensorOrientationFeature';
import { DartMessenger } from '../DartMessenger';
import { ZoomLevelFeature } from './zoomlevel/ZoomLevelFeature';
import { ExposurePointFeature } from './exposurepoint/ExposurePointFeature';
import { NoiseReductionFeature } from './noisereduction/NoiseReductionFeature';
import camera from '@ohos.multimedia.camera';

export class CameraFeatureFactoryImpl implements CameraFeatureFactory {
  createAutoFocusFeature(
    cameraProperties: CameraProperties, recordingVideo: boolean): AutoFocusFeature {
    return new AutoFocusFeature(cameraProperties, recordingVideo);
  }

  public createExposureLockFeature(cameraProperties: CameraProperties): ExposureLockFeature {
    return new ExposureLockFeature(cameraProperties);
  }

  public createExposureOffsetFeature(
    cameraProperties: CameraProperties): ExposureOffsetFeature {
    return new ExposureOffsetFeature(cameraProperties);
  }

  public createFlashFeature(cameraProperties: CameraProperties): FlashFeature {
    return new FlashFeature(cameraProperties);
  }

  public createResolutionFeature(
    cameraProperties: CameraProperties,
    initialSetting: ResolutionPreset,
    cameraName: string): ResolutionFeature {
    return new ResolutionFeature(cameraProperties, initialSetting, cameraName);
  }

  public createFocusPointFeature(
    cameraProperties: CameraProperties,
    sensorOrientationFeature: SensorOrientationFeature): FocusPointFeature {
    return new FocusPointFeature(cameraProperties, sensorOrientationFeature);
  }

  public createFpsRangeFeature(cameraProperties: CameraProperties): FpsRangeFeature {
    return new FpsRangeFeature(cameraProperties);
  }

  public createSensorOrientationFeature(
    cameraProperties: CameraProperties,
    ability: Ability,
    dartMessenger: DartMessenger): SensorOrientationFeature {
    return new SensorOrientationFeature(cameraProperties, ability, dartMessenger);
  }

  public createZoomLevelFeature(cameraProperties: CameraProperties): ZoomLevelFeature {
    return new ZoomLevelFeature(cameraProperties);
  }

  public createExposurePointFeature(
    cameraProperties: CameraProperties,
    sensorOrientationFeature: SensorOrientationFeature): ExposurePointFeature {
    return new ExposurePointFeature(cameraProperties, sensorOrientationFeature);
  }

  public createNoiseReductionFeature(
    cameraProperties: CameraProperties): NoiseReductionFeature {
    return new NoiseReductionFeature(cameraProperties);
  }
}