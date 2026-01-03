import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/onboarding_movies_page.dart';
import 'presentation/stores/paywall_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Setup dependency injection
  await setupDependencyInjection();
  
  // Initialize RevenueCat
  await getIt<PaywallStore>().init();
  
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
          title: 'Movie App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const OnboardingMoviesPage(),
        );
      },
    );
  }
}

