import 'package:mobx/mobx.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'dart:io';

part 'paywall_store.g.dart';

class PaywallStore = _PaywallStore with _$PaywallStore;

abstract class _PaywallStore with Store {
  static const String _apiKey = 'test_tZmEqBYtEZNRZFjAKgwmVRBxhNi';
  static const String _entitlementId = 'Movies Pro';

  @observable
  bool isLoading = false;

  @observable
  bool isPremium = false;

  @observable
  CustomerInfo? customerInfo;

  @observable
  String? error;

  @action
  Future<void> init() async {
    isLoading = true;
    try {
      // Configure RevenueCat
      final isConfigured = await Purchases.isConfigured;
      if (!isConfigured) {
        await Purchases.configure(PurchasesConfiguration(_apiKey));
      }

      // Check current customer info/entitlements
      customerInfo = await Purchases.getCustomerInfo();
      isPremium = customerInfo?.entitlements.active.containsKey(_entitlementId) ?? false;
      
      // Listen for database changes (automatic sync)
      Purchases.addCustomerInfoUpdateListener((info) {
        customerInfo = info;
        isPremium = info.entitlements.active.containsKey(_entitlementId);
      });

    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> presentPaywall() async {
    try {
      // Use RevenueCat's modern Paywall UI
      final result = await RevenueCatUI.presentPaywall();
      // Result can be used if needed, but the listener above will handle state updates
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> presentCustomerCenter() async {
    try {
      // Use RevenueCat's Customer Center for management
      await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> restorePurchases() async {
    isLoading = true;
    try {
      customerInfo = await Purchases.restorePurchases();
      isPremium = customerInfo?.entitlements.active.containsKey(_entitlementId) ?? false;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
