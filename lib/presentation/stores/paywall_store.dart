import 'package:mobx/mobx.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

part 'paywall_store.g.dart';

class PaywallStore = _PaywallStore with _$PaywallStore;

abstract class _PaywallStore with Store {
  String get _apiKey => dotenv.env['REVENUECAT_API_KEY'] ?? 'test_tZmEqBYtEZNRZFjAKgwmVRBxhNi';
  String get _entitlementId => dotenv.env['REVENUECAT_ENTITLEMENT_ID'] ?? 'Movies Pro';

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

  @observable
  int paywallVersion = 1; // 1 for Original, 2 for the new Full-Image version

  @action
  Future<void> init() async {
    print('PaywallStore: Initializing...');
    isLoading = true;
    try {
      // 1. Initialize RevenueCat
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

      // 2. Remote Config Logic
      await _fetchRemoteConfig();

    } catch (e) {
      print('PaywallStore: Error during init: $e');
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _fetchRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      
      // Configure settings (fetch timeout and minimum fetch interval)
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1), // Check every hour in prod, or less for testing
      ));

      // Set default values
      await remoteConfig.setDefaults({
        "paywall_version": 1, // Default to the new one
      });

      // Fetch and activate
      await remoteConfig.fetchAndActivate();
      
      // Update observable
      paywallVersion = remoteConfig.getInt("paywall_version");
      print('PaywallStore: Remote Config paywallVersion = $paywallVersion');

      // Log paywall view
      FirebaseAnalytics.instance.logEvent(
        name: 'paywall_view',
        parameters: {'version': paywallVersion},
      );
    } catch (e) {
      print('PaywallStore: Failed to fetch remote config: $e');
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
      
      if (isPremium) {
        FirebaseAnalytics.instance.logPurchase(
          currency: selectedPackage!.storeProduct.currencyCode,
          value: selectedPackage!.storeProduct.price,
          items: [
            AnalyticsEventItem(
              itemName: selectedPackage!.identifier,
              itemCategory: 'subscription',
            )
          ],
        );
      }
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
