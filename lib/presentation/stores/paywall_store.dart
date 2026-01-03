import 'package:mobx/mobx.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io';

part 'paywall_store.g.dart';

class PaywallStore = _PaywallStore with _$PaywallStore;

abstract class _PaywallStore with Store {
  @observable
  bool isLoading = false;

  @observable
  List<Package> packages = [];

  @observable
  Offering? currentOffering;

  @observable
  bool isPro = false;

  @observable
  String? error;

  @observable
  Package? selectedPackage;

  @observable
  bool freeTrialEnabled = true;

  @action
  Future<void> init() async {
    isLoading = true;
    try {
      // Replace with your RevenueCat API Keys
      final apiKey = Platform.isIOS 
          ? 'your_ios_api_key' 
          : 'your_android_api_key';
      
      await Purchases.configure(PurchasesConfiguration(apiKey));
      
      final customerInfo = await Purchases.getCustomerInfo();
      isPro = customerInfo.entitlements.active.containsKey('pro');

      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        currentOffering = offerings.current;
        packages = offerings.current!.availablePackages;
        if (packages.isNotEmpty) {
          // Select Monthly by default if exists
          selectedPackage = packages.firstWhere(
            (p) => p.packageType == PackageType.monthly,
            orElse: () => packages.first,
          );
        }
      }
    } catch (e) {
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
    error = null;
    try {
      final customerInfo = await Purchases.purchasePackage(selectedPackage!);
      isPro = customerInfo.entitlements.active.containsKey('pro');
      return isPro;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> restore() async {
    isLoading = true;
    try {
      final customerInfo = await Purchases.restorePurchases();
      isPro = customerInfo.entitlements.active.containsKey('pro');
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
