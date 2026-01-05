# Movies App

A beautiful Flutter movie discovery app with personalized recommendations, in-app purchases, and A/B testing capabilities.

## Features

- 🎬 Movie discovery with stunning UI
- 🎯 Personalized movie and genre selection during onboarding
- 💳 In-app subscriptions with RevenueCat
- 🔧 A/B testing for paywall designs via Firebase Remote Config
- 🥚 Developer Easter Egg for environment switching

---

## RevenueCat Implementation

### Setup

RevenueCat is used for handling in-app subscriptions. The implementation is located in:

- **Store**: `lib/presentation/stores/paywall_store.dart`
- **UI**: `lib/presentation/pages/paywall_page.dart` and `paywall_page_v2.dart`

### Configuration

1. API keys are stored in `.env` file:
   ```
   REVENUECAT_API_KEY=your_api_key_here
   REVENUECAT_ENTITLEMENT_ID=Movies Pro
   ```

2. The `PaywallStore` initializes RevenueCat on app startup:
   ```dart
   await Purchases.configure(PurchasesConfiguration(_apiKey));
   ```

### Features

- **Multiple Packages**: Supports monthly and yearly subscriptions
- **Custom Paywall UI**: Two paywall designs (V1 and V2) for A/B testing
- **Purchase Flow**: Full purchase handling with success/error states
- **Restore Purchases**: Users can restore previous purchases
- **Customer Center**: RevenueCat's built-in customer management UI

### Usage

```dart
final paywallStore = getIt<PaywallStore>();

// Check premium status
if (paywallStore.isPremium) {
  // User has active subscription
}

// Make a purchase
final success = await paywallStore.purchase();

// Restore purchases
await paywallStore.restorePurchases();
```

---

## Firebase Remote Config Implementation

### Setup

Firebase Remote Config is used for A/B testing different paywall designs without app updates.

- **Store**: `lib/presentation/stores/paywall_store.dart`
- **Firebase Options**: `lib/firebase_options.dart`

### Configuration

1. Add Firebase configuration files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

2. Create a parameter in Firebase Console:
   - Parameter name: `paywall_version`
   - Type: Number
   - Values: `1` (Original) or `2` (New Design)

### How It Works

On app startup, the `PaywallStore` fetches the remote config:

```dart
final remoteConfig = FirebaseRemoteConfig.instance;

await remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: const Duration(seconds: 10),
  minimumFetchInterval: Duration.zero,
));

await remoteConfig.setDefaults({
  "paywall_version": 2,
});

await remoteConfig.fetchAndActivate();
paywallVersion = remoteConfig.getInt("paywall_version");
```

### Paywall Routing

In `onboarding_genres_page.dart`, the paywall version determines which UI to show:

```dart
if (_paywallStore.paywallVersion == 2) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallPageV2()));
} else {
  Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallPage()));
}
```

### Analytics

Paywall views and purchases are logged to Firebase Analytics:

```dart
FirebaseAnalytics.instance.logEvent(
  name: 'paywall_view',
  parameters: {'version': paywallVersion},
);
```

---

## Easter Egg - Developer Options

### Location

The Easter Egg is located on the **Movie Selection Page** (`OnboardingMoviesPage`).

### How to Activate

1. Navigate to the movie selection screen (first onboarding screen)
2. **Tap 5 times** on the invisible area **directly above the "Continue" button**
3. Taps must be within **2 seconds** of each other
4. The **Developer Options** page will open

### Developer Options Features

The `EnvironmentSelectorPage` allows switching between:

| Environment | Description | Color |
|-------------|-------------|-------|
| Test | Testing with debug features | 🟠 Orange |
| Beta | Pre-release features | 🟣 Purple |
| Prod | Production environment | 🟢 Green |

### Implementation

```dart
void _handleEasterEggTap() {
  final now = DateTime.now();
  
  if (_lastTapTime != null && now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
    _easterEggTapCount = 0;
  }
  
  _lastTapTime = now;
  _easterEggTapCount++;
  
  if (_easterEggTapCount >= 5) {
    _easterEggTapCount = 0;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EnvironmentSelectorPage()),
    );
  }
}
```

### Environment Persistence

Selected environment is saved using `SharedPreferences` and persists across app restarts.

---

## Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart          # Dependency injection setup
│   └── theme/
│       └── app_theme.dart          # App colors and themes
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   │   ├── onboarding_movies_page.dart
│   │   ├── onboarding_genres_page.dart
│   │   ├── paywall_page.dart
│   │   ├── paywall_page_v2.dart
│   │   ├── environment_selector_page.dart
│   │   └── home_page.dart
│   └── stores/
│       ├── paywall_store.dart
│       ├── environment_store.dart
│       ├── onboarding_store.dart
│       └── home_store.dart
├── firebase_options.dart
└── main.dart
```

---

## Environment Variables

Create a `.env` file in the project root:

```env
TMDB_API_KEY=your_tmdb_api_key
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p
REVENUECAT_API_KEY=your_revenuecat_api_key
REVENUECAT_ENTITLEMENT_ID=Movies Pro
```

---

## Getting Started

1. Clone the repository
2. Create `.env` file with required keys
3. Add Firebase configuration files
4. Run `flutter pub get`
5. Run `dart run build_runner build`
6. Run `flutter run`

---

## Dependencies

- **State Management**: MobX
- **DI**: GetIt
- **Network**: Dio
- **In-App Purchases**: RevenueCat (purchases_flutter)
- **Analytics**: Firebase Analytics
- **Remote Config**: Firebase Remote Config
- **Storage**: SharedPreferences
