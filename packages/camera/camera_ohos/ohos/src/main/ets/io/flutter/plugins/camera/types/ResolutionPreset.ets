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

export enum ResolutionPreset {
  low,
  medium,
  high,
  veryHigh,
  ultraHigh,
  max,
}

export const ResolutionPreset_valueOf = (v: string): ResolutionPreset => {
  switch (v) {
    case 'low':
      return ResolutionPreset.low;
    case 'medium':
      return ResolutionPreset.medium;
    case 'high':
      return ResolutionPreset.high;
    case 'veryHigh':
      return ResolutionPreset.veryHigh;
    case 'ultraHigh':
      return ResolutionPreset.ultraHigh;
    case 'max':
      return ResolutionPreset.max;
    default:
      return ResolutionPreset.low;
  }
}
