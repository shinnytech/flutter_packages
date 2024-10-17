/*
* Copyright (c) 2024 SwanLink (Jiangsu) Technology Development Co., LTD.
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

import { Any } from '@ohos/flutter_ohos';

export class PurchaseOrderPayload {
  applicationId: string = '';
  countryCode: string = '';
  environment: string = '';
  payOrderId: string = '';
  price: number = 0;
  productId: string = '';
  productType: number = 0;
  purchaseOrderId: string = '';
  purchaseTime: number = 0;
  purchaseToken: string = '';
  signedTime: number = 0;
}

export class PurchaseSubGroupStatusPayload {
  environment: string = '';
  applicationId: string = '';
  packageName: string = '';
  subGroupId: string = '';
  lastSubscriptionStatus?: PurchaseSubscriptionStatus;
  historySubscriptionStatusList?: Any[] = [];
}

export class PurchaseSubscriptionStatus {
  subGroupGenerationId: string = '';
  subscriptionId: string = '';
  purchaseToken: string = '';
  status: string = '';
  expiresTime: number = 0;
  lastPurchaseOrder?: Any = {};
  recentPurchaseOrderList?: Any[] = [];
  renewalInfo?: Any = {};
}