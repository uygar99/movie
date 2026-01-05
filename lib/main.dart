import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/pages/onboarding_movies_page.dart';
import 'presentation/stores/onboarding_store.dart';
import 'presentation/stores/paywall_store.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    systemNavigationBarColor: Colors.black,
  ));
  
  await dotenv.load(fileName: '.env');
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await setupDependencyInjection();
  
  try {
    final onboardingStore = getIt<OnboardingStore>();
    final paywallStore = getIt<PaywallStore>();
    
    await Future.wait([
      paywallStore.init(),
      onboardingStore.loadMovies(),
      onboardingStore.loadGenres(),
    ]);
  } catch (e) {
    debugPrint('Init error: $e');
  }
  
  await Future.delayed(const Duration(milliseconds: 500));
  
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Movies',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          builder: (context, child) {
            return Container(
              color: Colors.black,
              child: child,
            );
          },
          home: const OnboardingMoviesPage(),
        );
      },
    );
  }
}
