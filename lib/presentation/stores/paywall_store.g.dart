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

  late final _$initAsyncAction = AsyncAction(
    '_PaywallStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$presentPaywallAsyncAction = AsyncAction(
    '_PaywallStore.presentPaywall',
    context: context,
  );

  @override
  Future<void> presentPaywall() {
    return _$presentPaywallAsyncAction.run(() => super.presentPaywall());
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

  late final _$restorePurchasesAsyncAction = AsyncAction(
    '_PaywallStore.restorePurchases',
    context: context,
  );

  @override
  Future<void> restorePurchases() {
    return _$restorePurchasesAsyncAction.run(() => super.restorePurchases());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isPremium: ${isPremium},
customerInfo: ${customerInfo},
error: ${error}
    ''';
  }
}
