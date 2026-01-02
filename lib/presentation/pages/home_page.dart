import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/genre.dart';
import '../stores/home_store.dart';
import '../stores/onboarding_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore _homeStore;
  final ScrollController _mainScrollController = ScrollController();
  final Map<int, GlobalKey> _genreKeys = {};

  @override
  void initState() {
    super.initState();
    _homeStore = getIt<HomeStore>();
    
    // Get selected IDs from onboarding (we should usually persist this or pass it)
    // For now, I'll try to get it from a singleton if OnboardingStore was one, 
    // but since it's a factory, let's assume we logic it.
    // Actually, I'll pass dummy data or try to find a way to get it.
    // In a real app, these would be in a UserStore.
    final onboardingStore = getIt<OnboardingStore>();
    _homeStore.init(
      onboardingStore.selectedGenreIds.toList(),
      onboardingStore.selectedMovieIds.toList(),
    );
  }

  void _scrollToGenre(int genreId) {
    final key = _genreKeys[genreId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _homeStore.setSelectedGenre(genreId);
    }
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
      body: SafeArea(
        child: CustomScrollView(
          controller: _mainScrollController,
          slivers: [
            // 1. FOR YOU SECTION
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                child: Text(
                  'For You ⭐',
                  style: GoogleFonts.inter(
                    color: AppTheme.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100.h,
                child: Observer(
                  builder: (_) {
                    if (_homeStore.isLoadingRecommended && _homeStore.recommendedMovies.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: AppTheme.redLight));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      itemCount: _homeStore.recommendedMovies.length,
                      itemBuilder: (context, index) {
                        final movie = _homeStore.recommendedMovies[index];
                        return Container(
                          width: 80.w,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white12,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: _getImageUrl(movie.posterPath),
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Center(child: Icon(Icons.movie, color: Colors.white24)),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Divider
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white10, thickness: 1),
              ),
            ),

            // 2. MOVIES SECTION HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movies 🎬',
                      style: GoogleFonts.inter(
                        color: AppTheme.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Search Bar
                    Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: AppTheme.grayDark, size: 20.w),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextField(
                              onChanged: _homeStore.setSearchQuery,
                              style: GoogleFonts.inter(color: AppTheme.white, fontSize: 16.sp),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: GoogleFonts.inter(color: AppTheme.grayDark, fontSize: 16.sp),
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                            ),
                          ),
                          Icon(Icons.mic, color: AppTheme.grayDark, size: 20.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // 3. GENRE CHIPS (Sticky behavior could be nice but let's start simple)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40.h,
                child: Observer(
                  builder: (_) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: _homeStore.genres.length,
                      itemBuilder: (context, index) {
                        final genre = _homeStore.genres[index];
                        final isSelected = _homeStore.selectedGenreId == genre.id;
                        return GestureDetector(
                          onTap: () => _scrollToGenre(genre.id),
                          child: Container(
                            margin: EdgeInsets.only(right: 12.w),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.redLight : AppTheme.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                if (isSelected) ...[
                                  Icon(Icons.check, color: AppTheme.white, size: 16.w),
                                  SizedBox(width: 4.w),
                                ],
                                Text(
                                  genre.name,
                                  style: GoogleFonts.inter(
                                    color: isSelected ? AppTheme.white : AppTheme.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
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
            ),

            // 4. CATEGORIES LIST
            Observer(
              builder: (_) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final genre = _homeStore.genres[index];
                      _genreKeys[genre.id] ??= GlobalKey();

                      return Container(
                        key: _genreKeys[genre.id],
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                genre.name,
                                style: GoogleFonts.inter(
                                  color: AppTheme.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _GenreMoviesGrid(
                              movies: _homeStore.moviesByGenre[genre.id] ?? [],
                              imageUrlGetter: _getImageUrl,
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: _homeStore.genres.length,
                  ),
                );
              },
            ),
            
            // Padding at bottom
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }
}

class _GenreMoviesGrid extends StatelessWidget {
  final List<Movie> movies;
  final String Function(String?) imageUrlGetter;

  const _GenreMoviesGrid({required this.movies, required this.imageUrlGetter});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return SizedBox(
        height: 150.h,
        child: const Center(child: CircularProgressIndicator(color: Colors.white10)),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length, // Already limited to 9 in store
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            color: Colors.white10,
            child: CachedNetworkImage(
              imageUrl: imageUrlGetter(movie.posterPath),
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const Icon(Icons.movie, color: Colors.white24),
            ),
          ),
        );
      },
    );
  }
}
