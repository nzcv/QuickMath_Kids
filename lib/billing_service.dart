import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BillingService {
  static const String _premiumProductId = 'premium_plan';
  static const String _premiumKey = 'is_premium';
  static final BillingService _instance = BillingService._internal();
  final InAppPurchase _iap = InAppPurchase.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isPremium = false;
  bool _isInitialized = false;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  factory BillingService() => _instance;

  BillingService._internal();

  bool get isPremium => _isPremium;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Check if billing is available
    final bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint('BillingService: In-app purchase not available');
      _isPremium = false;
      _isInitialized = true;
      return;
    }

    // Set up purchase stream listener
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('BillingService: Purchase stream error: $error'),
    );

    // Load initial premium status by restoring purchases
    await _loadPremiumStatus();
    _isInitialized = true;
  }

  Future<void> _loadPremiumStatus() async {
    // Read local flag
    String? localPremium = await _storage.read(key: _premiumKey);

    // Restore purchases and check via the stream
    bool isPurchased = false;
    final Completer<bool> completer = Completer<bool>();

    // Temporarily listen for purchase updates triggered by restorePurchases
    StreamSubscription<List<PurchaseDetails>>? tempSubscription;
    tempSubscription = _iap.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        for (var purchase in purchaseDetailsList) {
          if (purchase.productID == _premiumProductId &&
              purchase.status == PurchaseStatus.purchased) {
            isPurchased = true;
            completer.complete(true);
            tempSubscription?.cancel();
            break;
          }
        }
      },
      onDone: () {
        if (!completer.isCompleted) completer.complete(false);
      },
      onError: (error) {
        debugPrint('BillingService: Restore purchases error: $error');
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    // Trigger restore purchases
    await _iap.restorePurchases();

    // Wait for the stream to confirm purchase status
    await completer.future.timeout(const Duration(seconds: 5), onTimeout: () {
      debugPrint('BillingService: Restore purchases timed out');
      return false;
    });

    if (isPurchased) {
      // If purchased, ensure local flag is set
      if (localPremium != 'true') {
        await _storage.write(key: _premiumKey, value: 'true');
      }
      _isPremium = true;
    } else {
      // If not purchased, reset local flag if tampered
      if (localPremium == 'true') {
        await _storage.write(key: _premiumKey, value: 'false');
      }
      _isPremium = false;
    }
  }

  Future<bool> purchasePremium(BuildContext context) async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      _showSnackBar(context, 'In-app purchases are not available.');
      return false;
    }

    final ProductDetailsResponse response =
        await _iap.queryProductDetails({_premiumProductId});
    if (response.error != null || response.productDetails.isEmpty) {
      _showSnackBar(context, 'Product not found. Please try again later.');
      return false;
    }

    final ProductDetails product = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } catch (e) {
      debugPrint('BillingService: Purchase error: $e');
      _showSnackBar(context, 'Failed to initiate purchase. Please try again.');
      return false;
    }
  }

  Future<void> restorePurchase() async {
    await _loadPremiumStatus();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.productID == _premiumProductId) {
        switch (purchase.status) {
          case PurchaseStatus.purchased:
            _isPremium = true;
            _storage.write(key: _premiumKey, value: 'true');
            _iap.completePurchase(purchase);
            debugPrint('BillingService: Premium purchased successfully');
            break;
          case PurchaseStatus.pending:
            debugPrint('BillingService: Purchase pending');
            break;
          case PurchaseStatus.error:
          case PurchaseStatus.restored:
            debugPrint('BillingService: Purchase error/restored: ${purchase.error}');
            break;
          case PurchaseStatus.canceled:
            debugPrint('BillingService: Purchase canceled');
            break;
        }
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}