import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/movie.dart';
import '../stores/onboarding_store.dart';
import 'onboarding_genres_page.dart';

class OnboardingMoviesPage extends StatefulWidget {
  const OnboardingMoviesPage({super.key});

  @override
  State<OnboardingMoviesPage> createState() => _OnboardingMoviesPageState();
}

class _OnboardingMoviesPageState extends State<OnboardingMoviesPage> {
  late final OnboardingStore _store;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _store = getIt<OnboardingStore>();
    
    
    _pageController = PageController(
      viewportFraction: 0.52, 
      initialPage: 0,
    );
    
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        _store.updateWheelPosition(_pageController.page ?? 0);
        if ((_pageController.page ?? 0) >= _store.movies.length - 10) {
          _store.loadMovies(loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getImageUrl(String? path) {
    if (path == null) return '';
    final baseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return '$baseUrl/w500$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: Stack(
        children: [
          // 1. THE GLOBAL DRUM WHEEL
          Positioned.fill(
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
                    return _WheelCard(
                      index: index,
                      movie: _store.movies[index],
                      store: _store,
                      imageUrl: _getImageUrl(_store.movies[index].posterPath),
                    );
                  },
                );
              },
            ),
          ),

          // 2. HEADER CONTENT
          Positioned(
            top: 88.h, // Top must be 88px as requested
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
                        fontSize: 24.sp, // 24px as requested
                        fontWeight: FontWeight.w700, // Bold
                        height: 1.0,
                      ),
                    ),
                    if (!isReady) ...[
                      SizedBox(height: 12.h),
                      Text(
                        'Choose your 3 favorite movies',
                        style: GoogleFonts.inter(
                          color: AppTheme.grayDark,
                          fontSize: 20.sp, // 20px
                          fontWeight: FontWeight.w500, // Medium
                          height: 1.0,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),

          // 3. FOOTER BUTTON
          Positioned(
            top: 677.h, // Precise top positioning as requested
            left: 20.w, // Left positioning as requested
            child: Observer(
              builder: (_) {
                return SizedBox(
                  width: 335.w, // Fixed width: 335
                  height: 56.h, // Fixed height: 56
                  child: ElevatedButton(
                    onPressed: _store.canContinueFromMovies 
                      ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OnboardingGenresPage(store: _store)))
                      : null,
                    child: Text(
                      'Continue', 
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp, // 16px as requested
                        fontWeight: FontWeight.w600, // Semi Bold
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
    );
  }
}

class _WheelCard extends StatelessWidget {
  final int index;
  final Movie movie;
  final OnboardingStore store;
  final String imageUrl;

  const _WheelCard({
    required this.index,
    required this.movie,
    required this.store,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final double page = store.wheelScrollPosition;
        final double diff = index - page;
        
        const double slotWidth = 195.0; // 180w + 15px gap
        const double radius = 360.0;
        
        final double angle = (diff * slotWidth) / radius;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(
              (math.sin(angle) * radius) - (diff * slotWidth),
              0.0, 
              (math.cos(angle) - 1.0) * radius
            )
            ..rotateY(angle),
          child: Center(
            child: GestureDetector(
              onTap: () => store.toggleMovieSelection(movie.id),
              child: ClipPath(
                clipper: _GlobalDrumClipper(
                  globalAngle: angle,
                  radius: radius,
                  cardWidth: 180.w,
                ),
                child: _CardView(movie: movie, store: store, imageUrl: imageUrl),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlobalDrumClipper extends CustomClipper<Path> {
  final double globalAngle; 
  final double radius;
  final double cardWidth;

  _GlobalDrumClipper({
    required this.globalAngle,
    required this.radius,
    required this.cardWidth,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final double sweep = cardWidth / radius;
    final int segments = 20;
    const double viewLimitCos = 0.60; 

    for (int i = 0; i <= segments; i++) {
      final double t = i / segments;
      final double theta = globalAngle + (t - 0.5) * sweep;
      final double dy = (math.cos(theta) - viewLimitCos).clamp(0, 1) * radius * 0.22;
      if (i == 0) {
        path.moveTo(t * size.width, dy);
      } else {
        path.lineTo(t * size.width, dy);
      }
    }

    for (int i = segments; i >= 0; i--) {
      final double t = i / segments;
      final double theta = globalAngle + (t - 0.5) * sweep;
      final double dy = (math.cos(theta) - viewLimitCos).clamp(0, 1) * radius * 0.22;
      path.lineTo(t * size.width, size.height - dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_GlobalDrumClipper oldClipper) => 
      oldClipper.globalAngle != globalAngle;
}

class _CardView extends StatelessWidget {
  final Movie movie;
  final OnboardingStore store;
  final String imageUrl;

  const _CardView({required this.movie, required this.store, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isSelected = store.selectedMovieIds.contains(movie.id);

        return Container(
          width: 180.w,
          height: 252.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: const Color(0xFF1A1A1A),
            // Border is now extremely subtle as requested
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 1.w,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: Colors.white12),
                ),
                
                // INSET SHADOW EFFECT: box-shadow: 0px 0px 60px 24px #CB2C2C4D inset;
                if (isSelected)
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [
                            const Color(0x00CB2C2C), // Center transparent
                            AppTheme.selectionInsetRed, // Edges red (#CB2C2C4D)
                          ],
                          stops: const [0.4, 1.0], // Spread/Blur simulation
                        ),
                      ),
                    ),
                  ),

                // Checkmark - moved even higher as requested
                if (isSelected)
                  Positioned(
                    bottom: 45.h, 
                    right: 15.w,
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: const BoxDecoration(
                        color: AppTheme.redLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: AppTheme.white, size: 20.w),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
