import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../stores/onboarding_store.dart';
import '../stores/paywall_store.dart';
import 'onboarding_movies_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Minimum show time for splash (e.g. 2 seconds)
    final startTime = DateTime.now();

    try {
      // 2. Initialize necessary stores and fetch data
      final onboardingStore = getIt<OnboardingStore>();
      final paywallStore = getIt<PaywallStore>();

      // Run these in parallel
      await Future.wait([
        paywallStore.init(),
        onboardingStore.loadMovies(),
        onboardingStore.loadGenres(),
      ]);
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }

    // 3. Ensure we show splash for at least 2 seconds for that premium feel
    final elapsedTime = DateTime.now().difference(startTime);
    if (elapsedTime < const Duration(seconds: 2)) {
      await Future.delayed(const Duration(seconds: 2) - elapsedTime);
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingMoviesPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                image: const DecorationImage(
                  image: AssetImage('assets/app_logo.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // App Name
            Text(
              'Movies',
              style: GoogleFonts.inter(
                color: AppTheme.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            SizedBox(height: 60.h),
            // Optional: sleek loader
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.redLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
