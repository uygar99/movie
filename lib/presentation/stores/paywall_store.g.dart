// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PaywallStore on _PaywallStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_PaywallStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isPremiumAtom = Atom(
    name: '_PaywallStore.isPremium',
    context: context,
  );

  @override
  bool get isPremium {
    _$isPremiumAtom.reportRead();
    return super.isPremium;
  }

  @override
  set isPremium(bool value) {
    _$isPremiumAtom.reportWrite(value, super.isPremium, () {
      super.isPremium = value;
    });
  }

  late final _$customerInfoAtom = Atom(
    name: '_PaywallStore.customerInfo',
    context: context,
  );

  @override
  CustomerInfo? get customerInfo {
    _$customerInfoAtom.reportRead();
    return super.customerInfo;
  }

  @override
  set customerInfo(CustomerInfo? value) {
    _$customerInfoAtom.reportWrite(value, super.customerInfo, () {
      super.customerInfo = value;
    });
  }

  late final _$currentOfferingAtom = Atom(
    name: '_PaywallStore.currentOffering',
    context: context,
  );

  @override
  Offering? get currentOffering {
    _$currentOfferingAtom.reportRead();
    return super.currentOffering;
  }

  @override
  set currentOffering(Offering? value) {
    _$currentOfferingAtom.reportWrite(value, super.currentOffering, () {
      super.currentOffering = value;
    });
  }

  late final _$packagesAtom = Atom(
    name: '_PaywallStore.packages',
    context: context,
  );

  @override
  ObservableList<Package> get packages {
    _$packagesAtom.reportRead();
    return super.packages;
  }

  @override
  set packages(ObservableList<Package> value) {
    _$packagesAtom.reportWrite(value, super.packages, () {
      super.packages = value;
    });
  }

  late final _$selectedPackageAtom = Atom(
    name: '_PaywallStore.selectedPackage',
    context: context,
  );

  @override
  Package? get selectedPackage {
    _$selectedPackageAtom.reportRead();
    return super.selectedPackage;
  }

  @override
  set selectedPackage(Package? value) {
    _$selectedPackageAtom.reportWrite(value, super.selectedPackage, () {
      super.selectedPackage = value;
    });
  }

  late final _$freeTrialEnabledAtom = Atom(
    name: '_PaywallStore.freeTrialEnabled',
    context: context,
  );

  @override
  bool get freeTrialEnabled {
    _$freeTrialEnabledAtom.reportRead();
    return super.freeTrialEnabled;
  }

  @override
  set freeTrialEnabled(bool value) {
    _$freeTrialEnabledAtom.reportWrite(value, super.freeTrialEnabled, () {
      super.freeTrialEnabled = value;
    });
  }

  late final _$errorAtom = Atom(name: '_PaywallStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$paywallVersionAtom = Atom(
    name: '_PaywallStore.paywallVersion',
    context: context,
  );

  @override
  int get paywallVersion {
    _$paywallVersionAtom.reportRead();
    return super.paywallVersion;
  }

  @override
  set paywallVersion(int value) {
    _$paywallVersionAtom.reportWrite(value, super.paywallVersion, () {
      super.paywallVersion = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    '_PaywallStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$_fetchRemoteConfigAsyncAction = AsyncAction(
    '_PaywallStore._fetchRemoteConfig',
    context: context,
  );

  @override
  Future<void> _fetchRemoteConfig() {
    return _$_fetchRemoteConfigAsyncAction.run(
      () => super._fetchRemoteConfig(),
    );
  }

  late final _$purchaseAsyncAction = AsyncAction(
    '_PaywallStore.purchase',
    context: context,
  );

  @override
  Future<bool> purchase() {
    return _$purchaseAsyncAction.run(() => super.purchase());
  }

  late final _$restorePurchasesAsyncAction = AsyncAction(
    '_PaywallStore.restorePurchases',
    context: context,
  );

  @override
  Future<void> restorePurchases() {
    return _$restorePurchasesAsyncAction.run(() => super.restorePurchases());
  }

  late final _$presentCustomerCenterAsyncAction = AsyncAction(
    '_PaywallStore.presentCustomerCenter',
    context: context,
  );

  @override
  Future<void> presentCustomerCenter() {
    return _$presentCustomerCenterAsyncAction.run(
      () => super.presentCustomerCenter(),
    );
  }

  late final _$_PaywallStoreActionController = ActionController(
    name: '_PaywallStore',
    context: context,
  );

  @override
  void setSelectedPackage(Package package) {
    final _$actionInfo = _$_PaywallStoreActionController.startAction(
      name: '_PaywallStore.setSelectedPackage',
    );
    try {
      return super.setSelectedPackage(package);
    } finally {
      _$_PaywallStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleFreeTrial(bool value) {
    final _$actionInfo = _$_PaywallStoreActionController.startAction(
      name: '_PaywallStore.toggleFreeTrial',
    );
    try {
      return super.toggleFreeTrial(value);
    } finally {
      _$_PaywallStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isPremium: ${isPremium},
customerInfo: ${customerInfo},
currentOffering: ${currentOffering},
packages: ${packages},
selectedPackage: ${selectedPackage},
freeTrialEnabled: ${freeTrialEnabled},
error: ${error},
paywallVersion: ${paywallVersion}
    ''';
  }
}
