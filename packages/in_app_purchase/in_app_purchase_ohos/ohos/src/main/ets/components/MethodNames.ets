// Copyright (c) 2024 SwanLink (Jiangsu) Technology Development Co., LTD.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.

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