// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EnvironmentStore on _EnvironmentStore, Store {
  late final _$currentEnvironmentAtom = Atom(
    name: '_EnvironmentStore.currentEnvironment',
    context: context,
  );

  @override
  AppEnvironment get currentEnvironment {
    _$currentEnvironmentAtom.reportRead();
    return super.currentEnvironment;
  }

  @override
  set currentEnvironment(AppEnvironment value) {
    _$currentEnvironmentAtom.reportWrite(value, super.currentEnvironment, () {
      super.currentEnvironment = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    '_EnvironmentStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$setEnvironmentAsyncAction = AsyncAction(
    '_EnvironmentStore.setEnvironment',
    context: context,
  );

  @override
  Future<void> setEnvironment(AppEnvironment env) {
    return _$setEnvironmentAsyncAction.run(() => super.setEnvironment(env));
  }

  @override
  String toString() {
    return '''
currentEnvironment: ${currentEnvironment}
    ''';
  }
}
