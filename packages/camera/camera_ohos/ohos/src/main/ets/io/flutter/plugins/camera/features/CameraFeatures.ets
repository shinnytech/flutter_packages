/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CameraProperties } from '../CameraProperties';
import { CameraFeatureFactory } from './CameraFeatureFactory';
import Ability from '@ohos.app.ability.Ability';
import { DartMessenger } from '../DartMessenger';
import { ResolutionPreset } from './resolution/ResolutionPreset';
import { HashMap } from '@kit.ArkTS';
import { CameraFeature } from './CameraFeature';
import { ResolutionFeature } from './resolution/ResolutionFeature';
import { AutoFocusFeature } from './autofocus/AutoFocusFeature';
import { SensorOrientationFeature } from './sensororientation/SensorOrientationFeature';
import { ZoomLevelFeature } from './zoomlevel/ZoomLevelFeature';
import { NoiseReductionFeature } from './noisereduction/NoiseReductionFeature';
import { FpsRangeFeature } from './fpsrange/FpsRangeFeature';
import { FocusPointFeature } from './focuspoint/FocusPointFeature';
import { FlashFeature } from './flash/FlashFeature';
import { ExposurePointFeature } from './exposurepoint/ExposurePointFeature';
import { ExposureOffsetFeature } from './exposureoffset/ExposureOffsetFeature';
import { ExposureLockFeature } from './exposurelock/ExposureLockFeature';


const AUTO_FOCUS: string = "AUTO_FOCUS";
const EXPOSURE_LOCK: string = "EXPOSURE_LOCK";
const EXPOSURE_OFFSET: string = "EXPOSURE_OFFSET";
const EXPOSURE_POINT: string = "EXPOSURE_POINT";
const FLASH: string = "FLASH";
const FOCUS_POINT: string = "FOCUS_POINT";
const FPS_RANGE: string = "FPS_RANGE";
const NOISE_REDUCTION: string = "NOISE_REDUCTION";
const REGION_BOUNDARIES: string = "REGION_BOUNDARIES";
const RESOLUTION: string = "RESOLUTION";
const SENSOR_ORIENTATION: string = "SENSOR_ORIENTATION";
const ZOOM_LEVEL: string = "ZOOM_LEVEL";

export class CameraFeatures {
  static init(
    cameraFeatureFactory: CameraFeatureFactory,
    cameraProperties: CameraProperties,
    ability: Ability,
    dartMessenger: DartMessenger,
    resolutionPreset: ResolutionPreset
  ): CameraFeatures {
    const cameraFeatures: CameraFeatures = new CameraFeatures();
    cameraFeatures.setAutoFocus(
      cameraFeatureFactory.createAutoFocusFeature(cameraProperties, false));
    cameraFeatures.setExposureLock(
      cameraFeatureFactory.createExposureLockFeature(cameraProperties));
    cameraFeatures.setExposureOffset(
      cameraFeatureFactory.createExposureOffsetFeature(cameraProperties));
    let sensorOrientationFeature: SensorOrientationFeature =
      cameraFeatureFactory.createSensorOrientationFeature(
        cameraProperties, ability, dartMessenger);
    cameraFeatures.setSensorOrientation(sensorOrientationFeature);
    cameraFeatures.setExposurePoint(
      cameraFeatureFactory.createExposurePointFeature(
        cameraProperties, sensorOrientationFeature));
    cameraFeatures.setFlash(cameraFeatureFactory.createFlashFeature(cameraProperties));
    cameraFeatures.setFocusPoint(
      cameraFeatureFactory.createFocusPointFeature(cameraProperties, sensorOrientationFeature));
    cameraFeatures.setNoiseReduction(
      cameraFeatureFactory.createNoiseReductionFeature(cameraProperties));
    cameraFeatures.setResolution(
      cameraFeatureFactory.createResolutionFeature(
        cameraProperties, resolutionPreset, cameraProperties.getCameraName()));
    cameraFeatures.setZoomLevel(cameraFeatureFactory.createZoomLevelFeature(cameraProperties));
    return cameraFeatures;
  }

  private featureMap: HashMap<string, ESObject> = new HashMap();

  public setAutoFocus(autoFocus: AutoFocusFeature): void {
    this.featureMap.set(AUTO_FOCUS, autoFocus)
  }

  public getAutoFocus(): AutoFocusFeature {
    return this.featureMap.get(AUTO_FOCUS);
  }

  public getExposureLock(): ExposureLockFeature {
    return this.featureMap.get(EXPOSURE_LOCK)
  }

  public setExposureLock(exposureLock: ExposureLockFeature) {
    this.featureMap.set(EXPOSURE_LOCK, exposureLock)
  }


  public getExposureOffset(): ExposureOffsetFeature {
    return this.featureMap.get(EXPOSURE_OFFSET)
  }

  public setExposureOffset(exposureOffset: ExposureOffsetFeature) {
    this.featureMap.set(EXPOSURE_OFFSET, exposureOffset)
  }

  public getExposurePoint(): ExposurePointFeature {
    return this.featureMap.get(EXPOSURE_POINT)
  }

  public setExposurePoint(exposurePoint: ExposurePointFeature) {
    this.featureMap.set(EXPOSURE_POINT, exposurePoint)
  }

  public getFlash(): FlashFeature {
    return this.featureMap.get(FLASH)
  }

  public setFlash(flash: FlashFeature) {
    this.featureMap.set(FLASH, flash)
  }

  public getFocusPoint(): FocusPointFeature {
    return this.featureMap.get(FOCUS_POINT)
  }

  public setFocusPoint(focusPoint: FocusPointFeature) {
    this.featureMap.set(FOCUS_POINT, focusPoint)
  }

  public getFpsRange(): FpsRangeFeature {
    return this.featureMap.get(FPS_RANGE)
  }

  public setFpsRange(fpsRange: FpsRangeFeature) {
    this.featureMap.set(FPS_RANGE, fpsRange)
  }

  public getNoiseReduction(): NoiseReductionFeature {
    return this.featureMap.get(NOISE_REDUCTION)
  }

  public setNoiseReduction(noiseReduction: NoiseReductionFeature) {
    this.featureMap.set(NOISE_REDUCTION, noiseReduction)
  }

  public getSensorOrientation(): SensorOrientationFeature {
    return this.featureMap.get(SENSOR_ORIENTATION)
  }

  public setSensorOrientation(sensorOrientation: SensorOrientationFeature) {
    this.featureMap.set(SENSOR_ORIENTATION, sensorOrientation)
  }

  public getZoomLevel(): ZoomLevelFeature {
    return this.featureMap.get(ZOOM_LEVEL)
  }

  public setZoomLevel(zoomLevel: ZoomLevelFeature) {
    this.featureMap.set(ZOOM_LEVEL, zoomLevel)
  }

  public getResolution(): ResolutionFeature {
    return this.featureMap.get(RESOLUTION);
  }


  public setResolution(resolution: ResolutionFeature) {
    this.featureMap.set(RESOLUTION, resolution);
  }
}