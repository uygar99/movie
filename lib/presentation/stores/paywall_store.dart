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
  Offering? currentOffering;

  @observable
  ObservableList<Package> packages = ObservableList<Package>();

  @observable
  Package? selectedPackage;

  @observable
  bool freeTrialEnabled = false;

  @observable
  String? error;

  @action
  Future<void> init() async {
    print('PaywallStore: Initializing RevenueCat...');
    isLoading = true;
    try {
      final isConfigured = await Purchases.isConfigured;
      if (!isConfigured) {
        await Purchases.configure(PurchasesConfiguration(_apiKey));
      }

      // Check current customer info
      customerInfo = await Purchases.getCustomerInfo();
      isPremium = customerInfo?.entitlements.active.containsKey(_entitlementId) ?? false;
      
      // Fetch Offerings for custom UI
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        currentOffering = offerings.current;
        packages.clear();
        packages.addAll(offerings.current!.availablePackages);
        
        // Default selection: Monthly
        if (packages.isNotEmpty) {
          selectedPackage = packages.firstWhere(
            (p) => p.packageType == PackageType.monthly,
            orElse: () => packages.first,
          );
        }
      }

      Purchases.addCustomerInfoUpdateListener((info) {
        customerInfo = info;
        isPremium = info.entitlements.active.containsKey(_entitlementId);
      });

    } catch (e) {
      print('PaywallStore: Error during init: $e');
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void setSelectedPackage(Package package) {
    selectedPackage = package;
  }

  @action
  void toggleFreeTrial(bool value) {
    freeTrialEnabled = value;
  }

  @action
  Future<bool> purchase() async {
    if (selectedPackage == null) return false;
    
    isLoading = true;
    try {
      final updatedCustomerInfo = await Purchases.purchasePackage(selectedPackage!);
      isPremium = updatedCustomerInfo.customerInfo.entitlements.active.containsKey(_entitlementId);
      return isPremium;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
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

  @action
  Future<void> presentCustomerCenter() async {
    try {
      await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      error = e.toString();
    }
  }
}
