import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie/presentation/pages/paywall_page.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../stores/onboarding_store.dart';
import '../stores/paywall_store.dart';
import 'home_page.dart';

class OnboardingGenresPage extends StatefulWidget {
  final OnboardingStore store;

  const OnboardingGenresPage({super.key, required this.store});

  @override
  State<OnboardingGenresPage> createState() => _OnboardingGenresPageState();
}

class _OnboardingGenresPageState extends State<OnboardingGenresPage> {
  late final PaywallStore _paywallStore;

  @override
  void initState() {
    super.initState();
    _paywallStore = getIt<PaywallStore>();
  }

  Future<void> _onContinue() async {
    // Automatically show custom paywall if user is not premium
    if (!_paywallStore.isPremium) {
      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PaywallPage()),
        );
      }
    }

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.06, -1.0),
            end: Alignment(-0.06, 1.0),
            colors: [
              AppTheme.black,
              Color(0x000F0E0E),
            ],
            stops: [0.0273, 0.9728],
          ),
        ),
        child: Stack(
          children: [
            // 1. Header (Dynamic Title/Desc)
            Positioned(
              top: 88.h,
              left: 20.w,
              right: 20.w,
              child: Observer(
                builder: (_) {
                  final isReady = widget.store.canContinueFromGenres;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isReady ? 'Thank you 👍' : 'Welcome',
                        style: GoogleFonts.inter(
                          color: AppTheme.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                      if (!isReady) ...[
                        SizedBox(height: 12.h),
                        Text(
                          'Choose your 2 favorite genres',
                          style: GoogleFonts.inter(
                            color: AppTheme.grayDark,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),

            // 2. Genres Grid
            Positioned(
              top: 180.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: Observer(
                builder: (_) {
                  if (widget.store.genres.isEmpty && widget.store.isLoadingGenres) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.redLight));
                  }

                  return Stack(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.only(
                          left: 30.w,
                          right: 30.w,
                          top: 20.h,
                          bottom: 150.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 25.w,
                          mainAxisSpacing: 25.h,
                        ),
                        itemCount: widget.store.genres.length,
                        itemBuilder: (context, index) {
                          // CORRECT MOBX PRACTICE: Wrap individual items in Observer for reactive updates
                          return Observer(
                            builder: (_) {
                              final genre = widget.store.genres[index];
                              final isSelected = widget.store.selectedGenreIds.contains(genre.id);

                              return GestureDetector(
                                onTap: () => widget.store.toggleGenreSelection(genre.id),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 140.w,
                                  height: 140.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(72.r),
                                    color: AppTheme.white,
                                    border: Border.all(
                                      color: isSelected ? AppTheme.redLight : Colors.transparent,
                                      width: 2.w,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: AppTheme.redLight.withOpacity(0.3),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                                          child: Text(
                                            genre.name,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.titleLarge,
                                          ),
                                        ),
                                      ),
                                      
                                      if (isSelected)
                                        IgnorePointer(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                center: Alignment.center,
                                                radius: 1.0,
                                                colors: [
                                                  Colors.transparent,
                                                  AppTheme.redLight.withOpacity(0.15),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                      if (isSelected)
                                        Positioned(
                                          bottom: 4.h,
                                          right: 4.w,
                                          child: Container(
                                            width: 32.w,
                                            height: 32.h,
                                            padding: EdgeInsets.all(6.12.w),
                                            decoration: const BoxDecoration(
                                              color: AppTheme.redLight,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const FittedBox(
                                              child: Icon(Icons.check, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      
                      // Masks
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 60.h,
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppTheme.black, AppTheme.black.withOpacity(0)],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 150.h,
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [AppTheme.black.withOpacity(0.9), AppTheme.black.withOpacity(0)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 3. Footer Button
            Positioned(
              top: 677.h,
              left: 20.w,
              child: Observer(
                builder: (_) {
                  return SizedBox(
                    width: 335.w,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: widget.store.canContinueFromGenres ? _onContinue : null,
                      child: Text(
                        'Continue',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                          height: 1.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
