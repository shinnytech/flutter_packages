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

import Ability from '@ohos.app.ability.Ability';
import { CameraProperties } from '../CameraProperties';
import { AutoFocusFeature } from './autofocus/AutoFocusFeature';
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

export interface CameraFeatureFactory {

  /**
   * Creates a new instance of the auto focus feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @param recordingVideo indicates if the camera is currently recording.
   * @return newly created instance of the AutoFocusFeature class.
   */
  createAutoFocusFeature(cameraProperties: CameraProperties, recordingVideo: boolean): AutoFocusFeature;

  /**
   * Creates a new instance of the exposure lock feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @return newly created instance of the ExposureLockFeature class.
   */
  createExposureLockFeature(cameraProperties: CameraProperties): ExposureLockFeature;

  /**
   * Creates a new instance of the exposure offset feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @return newly created instance of the ExposureOffsetFeature class.
   */
  createExposureOffsetFeature(cameraProperties: CameraProperties): ExposureOffsetFeature;

  /**
   * Creates a new instance of the flash feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @return newly created instance of the FlashFeature class.
   */
  createFlashFeature(cameraProperties: CameraProperties): FlashFeature;

  /**
   * Creates a new instance of the resolution feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @param initialSetting initial resolution preset.
   * @param cameraName the name of the camera which can be used to identify the camera device.
   * @return newly created instance of the ResolutionFeature class.
   */
  createResolutionFeature(
    cameraProperties: CameraProperties,
    initialSetting: ResolutionPreset,
    cameraName: string): ResolutionFeature;

  /**
   * Creates a new instance of the focus point feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @param sensorOrientationFeature instance of the SensorOrientationFeature class containing
   *     information about the sensor and device orientation.
   * @return newly created instance of the FocusPointFeature class.
   */

  createFocusPointFeature(
    cameraProperties: CameraProperties,
    sensorOrientationFeature: SensorOrientationFeature): FocusPointFeature;

  /**
   * Creates a new instance of the FPS range feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @return newly created instance of the FpsRangeFeature class.
   */

  createFpsRangeFeature(cameraProperties: CameraProperties): FpsRangeFeature;

  /**
   * Creates a new instance of the sensor orientation feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @param activity current activity associated with the camera plugin.
   * @param dartMessenger instance of the DartMessenger class, used to send state updates back to
   *     Dart.
   * @return newly created instance of the SensorOrientationFeature class.
   */

  createSensorOrientationFeature(
    cameraProperties: CameraProperties,
    ability: Ability,
    dartMessenger: DartMessenger): SensorOrientationFeature;

  /**
   * Creates a new instance of the zoom level feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @return newly created instance of the ZoomLevelFeature class.
   */

  createZoomLevelFeature(cameraProperties: CameraProperties): ZoomLevelFeature;

  /**
   * Creates a new instance of the exposure point feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @param sensorOrientationFeature instance of the SensorOrientationFeature class containing
   *     information about the sensor and device orientation.
   * @return newly created instance of the ExposurePointFeature class.
   */

  createExposurePointFeature(
    cameraProperties: CameraProperties,
    sensorOrientationFeature: SensorOrientationFeature): ExposurePointFeature;

  /**
   * Creates a new instance of the noise reduction feature.
   *
   * @param cameraProperties instance of the CameraProperties class containing information about the
   *     cameras features.
   * @return newly created instance of the NoiseReductionFeature class.
   */

  createNoiseReductionFeature(cameraProperties: CameraProperties): NoiseReductionFeature;
}
