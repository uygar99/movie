import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../stores/onboarding_store.dart';
import 'home_page.dart';

class OnboardingGenresPage extends StatefulWidget {
  final OnboardingStore store;

  const OnboardingGenresPage({super.key, required this.store});

  @override
  State<OnboardingGenresPage> createState() => _OnboardingGenresPageState();
}

class _OnboardingGenresPageState extends State<OnboardingGenresPage> {
  @override
  void initState() {
    super.initState();
    widget.store.loadGenres();
  }

  void _onContinue() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Observer(
                builder: (_) {
                  final hasSelection = widget.store.selectedGenreIds.isNotEmpty;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasSelection ? 'Thank you 👍' : 'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Choose your 2 favorite genres',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Genres Grid
            Expanded(
              child: Observer(
                builder: (_) {
                  if (widget.store.genres.isEmpty && widget.store.isLoadingGenres) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white24));
                  }

                  if (widget.store.genresError != null && widget.store.genres.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.store.genresError!, style: const TextStyle(color: Colors.white70)),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => widget.store.loadGenres(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: widget.store.genres.length,
                    itemBuilder: (context, index) {
                      final genre = widget.store.genres[index];
                      final isSelected = widget.store.selectedGenreIds.contains(genre.id);

                      return GestureDetector(
                        onTap: () => widget.store.toggleGenreSelection(genre.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFCC3333)
                                  : Colors.transparent,
                              width: 2.w,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Text(
                                    genre.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  bottom: 12.h,
                                  right: 12.w,
                                  child: Container(
                                    width: 24.w,
                                    height: 24.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFCC3333),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14.w,
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
            ),

            // Continue Button
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Observer(
                builder: (_) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.store.canContinueFromGenres ? _onContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC3333),
                        disabledBackgroundColor: const Color(0xFFCC3333).withOpacity(0.15),
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
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
