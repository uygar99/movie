import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/image_url_helper.dart';
import '../stores/onboarding_store.dart';
import '../widgets/onboarding/wheel_card.dart';
import 'onboarding_genres_page.dart';
import 'environment_selector_page.dart';

class OnboardingMoviesPage extends StatefulWidget {
  const OnboardingMoviesPage({super.key});

  @override
  State<OnboardingMoviesPage> createState() => _OnboardingMoviesPageState();
}

class _OnboardingMoviesPageState extends State<OnboardingMoviesPage> {
  late final OnboardingStore _store;
  late final PageController _pageController;
  
  int _easterEggTapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _store = getIt<OnboardingStore>();
    
    _pageController = PageController(
      viewportFraction: 0.52, 
      initialPage: 0,
    );
    
    _pageController.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    if (_pageController.hasClients) {
      _store.updateWheelPosition(_pageController.page ?? 0);
      if ((_pageController.page ?? 0) >= _store.movies.length - 10) {
        _store.loadMovies(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getImageUrl(String? path) {
    return ImageUrlHelper.getMoviePosterUrl(path);
  }

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

  void _navigateToGenres() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OnboardingGenresPage(store: _store)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: Stack(
        children: [
          _buildMovieWheel(),
          _buildHeader(),
          _buildEasterEggArea(),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildMovieWheel() {
    return Positioned.fill(
      child: Observer(
        builder: (_) {
          if (_store.movies.isEmpty && _store.isLoadingMovies) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.redLight));
          }
          return PageView.builder(
            controller: _pageController,
            itemCount: _store.movies.length,
            pageSnapping: false,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return WheelCard(
                index: index,
                movie: _store.movies[index],
                store: _store,
                imageUrl: _getImageUrl(_store.movies[index].posterPath),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 88.h,
      left: 20.w,
      right: 20.w,
      child: Observer(
        builder: (_) {
          final isReady = _store.canContinueFromMovies;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isReady ? 'Continue to next step 👉' : 'Welcome',
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
                  'Choose your 3 favorite movies',
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
    );
  }

  Widget _buildEasterEggArea() {
    return Positioned(
      top: 617.h,
      left: 20.w,
      child: GestureDetector(
        onTap: _handleEasterEggTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 335.w,
          height: 50.h,
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Positioned(
      top: 677.h,
      left: 20.w,
      child: Observer(
        builder: (_) {
          return SizedBox(
            width: 335.w,
            height: 56.h,
            child: ElevatedButton(
              onPressed: _store.canContinueFromMovies ? _navigateToGenres : null,
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
    );
  }
}
