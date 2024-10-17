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

export class MethodNames {
  static QUERY_ENVIRONMENT_STATUS: string = "iap#queryEnvironmentStatus";
  static QUERY_PRODUCTS: string = "iap#queryProducts";
  static CREATE_PURCHASE: string = "iap#createPurchase";
  static START_OBSERVING_TRANSACTION_QUEUE: string = "iap#startObservingTransactionQueue";
  static STOP_OBSERVING_TRANSACTION_QUEUE: string = "iap#stopObservingTransactionQueue";
  static RETRIEVE_RECEIPT_DATA: string = "iap#retrieveReceiptData";
  static TRANSACTIONS: string = "iap#transactions";
  static FINISH_PURCHASE: string = "iap#finishPurchase";
  static RESTORE_TRANSACTIONS: string = "iap#restoreTransactions";
}