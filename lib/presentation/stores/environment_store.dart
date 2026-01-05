import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'environment_store.g.dart';

enum AppEnvironment {
  test,
  beta,
  prod;

  String get displayName {
    switch (this) {
      case AppEnvironment.test:
        return 'Test';
      case AppEnvironment.beta:
        return 'Beta';
      case AppEnvironment.prod:
        return 'Production';
    }
  }

  String get description {
    switch (this) {
      case AppEnvironment.test:
        return 'Testing environment with debug features';
      case AppEnvironment.beta:
        return 'Beta testing with pre-release features';
      case AppEnvironment.prod:
        return 'Production environment';
    }
  }
}

class EnvironmentStore = _EnvironmentStore with _$EnvironmentStore;

abstract class _EnvironmentStore with Store {
  static const String _envKey = 'app_environment';

  @observable
  AppEnvironment currentEnvironment = AppEnvironment.prod;

  @action
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final envIndex = prefs.getInt(_envKey) ?? AppEnvironment.prod.index;
    currentEnvironment = AppEnvironment.values[envIndex];
  }

  @action
  Future<void> setEnvironment(AppEnvironment env) async {
    currentEnvironment = env;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_envKey, env.index);
  }

  String get apiBaseUrl {
    switch (currentEnvironment) {
      case AppEnvironment.test:
        return 'https://api.themoviedb.org/3';
      case AppEnvironment.beta:
        return 'https://api.themoviedb.org/3';
      case AppEnvironment.prod:
        return 'https://api.themoviedb.org/3';
    }
  }

  bool get isDebugMode => currentEnvironment != AppEnvironment.prod;
}
