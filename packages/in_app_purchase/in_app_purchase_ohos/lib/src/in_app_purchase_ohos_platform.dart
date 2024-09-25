// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

import '../iap_kit_wrappers.dart';
import '../in_app_purchase_ohos.dart';

/// [IAPError.code] code for failed purchases.
const String kPurchaseErrorCode = 'purchase_error';

/// Indicates store front is AppGallery.
const String kIAPSource = 'app_gallery';

/// An [InAppPurchasePlatform] that wraps IAP Kit.
///
/// This translates various `IAP Kit` calls and responses into the
/// generic plugin API.
class InAppPurchaseOhosPlatform extends InAppPurchasePlatform {
  /// Creates an [InAppPurchaseOhosPlatform] object.
  ///
  /// This constructor should only be used for testing, for any other purpose
  /// get the connection from the [instance] getter.
  @visibleForTesting
  InAppPurchaseOhosPlatform();

  static late IKPaymentQueueWrapper _skPaymentQueueWrapper;
  static late _TransactionObserver _observer;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _observer.purchaseUpdatedController.stream;

  /// Callback handler for transaction status changes.
  @visibleForTesting
  static IKTransactionObserverWrapper get observer => _observer;

  /// Registers this class as the default instance of [InAppPurchasePlatform].
  static void registerPlatform() {
    // Register the [InAppPurchaseOhosPlatformAddition] containing
    // IapKit-specific functionality.
    InAppPurchasePlatformAddition.instance =
        InAppPurchaseOhosPlatformAddition();

    // Register the platform-specific implementation of the idiomatic
    // InAppPurchase API.
    InAppPurchasePlatform.instance = InAppPurchaseOhosPlatform();

    _skPaymentQueueWrapper = IKPaymentQueueWrapper();

    // Create a purchaseUpdatedController and notify the native side when to
    // start of stop sending updates.
    final StreamController<List<PurchaseDetails>> updateController =
        StreamController<List<PurchaseDetails>>.broadcast(
      onListen: () => _skPaymentQueueWrapper.startObservingTransactionQueue(),
      onCancel: () => _skPaymentQueueWrapper.stopObservingTransactionQueue(),
    );
    _observer = _TransactionObserver(updateController);
    _skPaymentQueueWrapper.setTransactionObserver(observer);
  }

  @override
  Future<bool> isAvailable() => IKPaymentQueueWrapper.queryEnvironmentStatus();

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    await _skPaymentQueueWrapper.addPayment(
        IKPaymentWrapper(productId: purchaseParam.productDetails.id));
    return true; // There's no error feedback from ohos here to return.
  }

  @override
  Future<bool> buyConsumable(
      {required PurchaseParam purchaseParam, bool autoConsume = true}) {
    assert(autoConsume == true, 'On ohos, we should always auto consume');
    return buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    assert(
      purchase is AppGalleryPurchaseDetails,
      'On ohos, the `purchase` should always be of type `AppGalleryPurchaseDetails`.',
    );

    return _skPaymentQueueWrapper.finishTransaction(
      (purchase as AppGalleryPurchaseDetails).ikPaymentTransaction,
    );
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    return _observer
        .restoreTransactions(
            queue: _skPaymentQueueWrapper,
            applicationUserName: applicationUserName)
        .whenComplete(() => _observer.cleanUpRestoredTransactions());
  }

  /// Query the product detail list.
  ///
  /// This method only returns [ProductDetailsResponse].
  /// To get detailed Store Kit product list, use [SkProductResponseWrapper.startProductRequest]
  /// to get the [IKProductResponseWrapper].
  @override
  Future<ProductDetailsResponse> queryProductDetails(
      Set<String> identifiers) async {
    final IKRequestMaker requestMaker = IKRequestMaker();
    IKProductResponseWrapper response;
    PlatformException? exception;
    try {
      response = await requestMaker.startProductRequest(identifiers.toList());
      print('InAppPurchasePlugin productDetailResponse response');
    } on PlatformException catch (e) {
      exception = e;
      response = IKProductResponseWrapper(
          products: const <IKProductWrapper>[],
          invalidProductIdentifiers: identifiers.toList());
    }
    List<AppGalleryProductDetails> productDetails =
        <AppGalleryProductDetails>[];
    productDetails = response.products
        .map((IKProductWrapper productWrapper) =>
            AppGalleryProductDetails.fromIKProduct(productWrapper))
        .toList();
    List<String> invalidIdentifiers = response.invalidProductIdentifiers;
    if (productDetails.isEmpty) {
      invalidIdentifiers = identifiers.toList();
    }
    final ProductDetailsResponse productDetailsResponse =
        ProductDetailsResponse(
      productDetails: productDetails,
      notFoundIDs: invalidIdentifiers,
      error: exception == null
          ? null
          : IAPError(
              source: kIAPSource,
              code: exception.code,
              message: exception.message ?? '',
              details: exception.details),
    );
    return productDetailsResponse;
  }
}

enum _TransactionRestoreState {
  notRunning,
  waitingForTransactions,
  receivedTransaction,
}

class _TransactionObserver implements IKTransactionObserverWrapper {
  _TransactionObserver(this.purchaseUpdatedController);

  final StreamController<List<PurchaseDetails>> purchaseUpdatedController;

  Completer<void>? _restoreCompleter;
  late String _receiptData;
  _TransactionRestoreState _transactionRestoreState =
      _TransactionRestoreState.notRunning;

  Future<void> restoreTransactions({
    required IKPaymentQueueWrapper queue,
    String? applicationUserName,
  }) {
    _transactionRestoreState = _TransactionRestoreState.waitingForTransactions;
    _restoreCompleter = Completer<void>();
    queue.restoreTransactions(applicationUserName: applicationUserName);
    return _restoreCompleter!.future;
  }

  void cleanUpRestoredTransactions() {
    _restoreCompleter = null;
  }

  @override
  void updatedTransactions(
      {required List<IKPaymentTransactionWrapper> transactions}) {
    _handleTransationUpdates(transactions);
  }

  @override
  void removedTransactions(
      {required List<IKPaymentTransactionWrapper> transactions}) {}

  Future<String> getReceiptData() async {
    try {
      _receiptData = await IKReceiptManager.retrieveReceiptData();
    } catch (e) {
      _receiptData = '';
    }
    return _receiptData;
  }

  Future<void> _handleTransationUpdates(
      List<IKPaymentTransactionWrapper> transactions) async {
    print('MethodCallHandlerImpl _handleTransationUpdates ');
    if (_transactionRestoreState ==
            _TransactionRestoreState.waitingForTransactions &&
        transactions.any((IKPaymentTransactionWrapper transaction) =>
            transaction.transactionState ==
            IKPaymentTransactionStateWrapper.restored)) {
      _transactionRestoreState = _TransactionRestoreState.receivedTransaction;
    }

    final String receiptData = await getReceiptData();
    final List<PurchaseDetails> purchases = transactions
        .map((IKPaymentTransactionWrapper transaction) =>
            AppGalleryPurchaseDetails.fromIKTransaction(
                transaction, receiptData))
        .toList();
    purchaseUpdatedController.add(purchases);
  }
}
