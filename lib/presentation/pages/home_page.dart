import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobx/mobx.dart';
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
  final ScrollController _chipScrollController = ScrollController();
  final Map<int, GlobalKey> _genreKeys = {};
  
  static final double _chipWidth = 110.w;
  static const double _headerHeight = 60.0;

  ReactionDisposer? _scrollReaction;

  @override
  void initState() {
    super.initState();
    _homeStore = getIt<HomeStore>();
    
    final onboardingStore = getIt<OnboardingStore>();
    _homeStore.init(
      onboardingStore.selectedGenreIds.toList(),
      onboardingStore.selectedMovieIds.toList(),
    );

    _scrollReaction = reaction(
      (_) => _homeStore.selectedGenreId,
      (int id) => _centerSelectedChip(id),
    );
  }

  @override
  void dispose() {
    _scrollReaction?.call();
    _mainScrollController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  void _syncMainToChips() {
    if (_homeStore.isAutoScrolling || _homeStore.genres.isEmpty) return;

    final double topPadding = MediaQuery.of(context).padding.top;
    final double stickyEdge = topPadding + _headerHeight + 10.h;

    int? detectedId;

    for (int i = 0; i < _homeStore.genres.length; i++) {
      final genreId = _homeStore.genres[i].id;
      final key = _genreKeys[genreId];
      final ctx = key?.currentContext;
      
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final top = box.localToGlobal(Offset.zero).dy;
        
        double? bottom;
        if (i + 1 < _homeStore.genres.length) {
          final nextKey = _genreKeys[_homeStore.genres[i + 1].id];
          final nextCtx = nextKey?.currentContext;
          if (nextCtx != null) {
            bottom = (nextCtx.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy;
          }
        }

        if (top <= stickyEdge + 20) {
          if (bottom == null || bottom > stickyEdge) {
            detectedId = genreId;
            break;
          }
        }
      }
    }

    if (_mainScrollController.offset < 150.h) {
      detectedId = _homeStore.genres.first.id;
    }

    if (detectedId != null && _homeStore.selectedGenreId != detectedId) {
      _homeStore.setSelectedGenre(detectedId);
    }
  }

  void _onChipTap(int genreId) async {
    if (_homeStore.isAutoScrolling) return;

    _homeStore.setAutoScrolling(true);
    _homeStore.setSelectedGenre(genreId);

    final key = _genreKeys[genreId];
    final ctx = key?.currentContext;
    if (ctx != null) {
      final box = ctx.findRenderObject() as RenderBox;
      final dy = box.localToGlobal(Offset.zero).dy;
      final currentOffset = _mainScrollController.offset;
      final double topPadding = MediaQuery.of(context).padding.top;
      
      double target = currentOffset + dy - (topPadding + _headerHeight.h) + 2.h;

      await _mainScrollController.animateTo(
        target.clamp(0.0, _mainScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }

    await Future.delayed(const Duration(milliseconds: 100));
    _homeStore.setAutoScrolling(false);
  }

  void _centerSelectedChip(int genreId) {
    if (!_chipScrollController.hasClients) return;
    
    final index = _homeStore.genres.indexWhere((g) => g.id == genreId);
    if (index == -1) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final double centerOffset = (index * _chipWidth) - (screenWidth / 2) + (_chipWidth / 2) + 15.w;
    
    _chipScrollController.animateTo(
      centerOffset.clamp(0.0, _chipScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _syncMainToChips();
            return false;
          },
          child: CustomScrollView(
            controller: _mainScrollController,
            slivers: [
              _buildSectionHeader('For You ⭐'),
              _buildRecommendations(),
              const SliverToBoxAdapter(child: Divider(color: Colors.white10, height: 40, thickness: 1)),
              _buildMoviesHeader(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              Observer(
                builder: (_) {
                  if (_homeStore.searchQuery.isNotEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                  
                  return SliverPersistentHeader(
                    pinned: true,
                    delegate: _GenreNavDelegate(
                      homeStore: _homeStore,
                      chipScrollController: _chipScrollController,
                      chipWidth: _chipWidth,
                      onTap: _onChipTap,
                    ),
                  );
                },
              ),

              _buildCategoryList(),
              
              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
        child: Text(title,
          style: GoogleFonts.inter(color: AppTheme.white, fontSize: 24.sp, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildMoviesHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Movies 🎬',
              style: GoogleFonts.inter(color: AppTheme.white, fontSize: 24.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 16.h),
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF2EBEB),
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(CupertinoIcons.search, color: const Color(0xFF9E9E9E), size: 24.w),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      onChanged: _homeStore.setSearchQuery,
                      style: GoogleFonts.inter(color: Colors.black87, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF9E9E9E), fontSize: 17.sp, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                  Icon(CupertinoIcons.mic_fill, color: const Color(0xFF9E9E9E), size: 24.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return SliverToBoxAdapter(
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
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: _getImageUrl(movie.posterPath),
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.white12),
                    errorWidget: (_, __, ___) => const Center(child: Icon(Icons.movie, color: Colors.white24)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Observer(
      builder: (_) {
        if (_homeStore.isLoadingGenres && _homeStore.genres.isEmpty) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        }
        
        return SliverToBoxAdapter(
          child: Column(
            children: List.generate(_homeStore.genres.length, (index) {
              final genre = _homeStore.genres[index];
              _genreKeys[genre.id] ??= GlobalKey();

              return Observer(
                builder: (_) {
                  var movies = _homeStore.moviesByGenre[genre.id] ?? [];
                  
                  if (_homeStore.searchQuery.isNotEmpty) {
                    movies = movies.where((m) => m.title.toLowerCase().contains(_homeStore.searchQuery.toLowerCase())).toList();
                  }

                  if (movies.isEmpty && _homeStore.searchQuery.isNotEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    key: _genreKeys[genre.id],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 15.h),
                        child: Text(genre.name,
                          style: GoogleFonts.inter(color: AppTheme.white, fontSize: 20.sp, fontWeight: FontWeight.w700)),
                      ),
                      _MovieGrid(
                        movies: movies,
                        onImage: _getImageUrl,
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}

class _GenreNavDelegate extends SliverPersistentHeaderDelegate {
  final HomeStore homeStore;
  final ScrollController chipScrollController;
  final double chipWidth;
  final Function(int) onTap;

  _GenreNavDelegate({
    required this.homeStore,
    required this.chipScrollController,
    required this.chipWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.black,
      height: 60.h,
      child: Observer(
        builder: (_) {
          final selectedId = homeStore.selectedGenreId;
          
          return ListView.builder(
            controller: chipScrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            itemCount: homeStore.genres.length,
            itemBuilder: (context, index) {
              final genre = homeStore.genres[index];
              final isSelected = selectedId == genre.id;
              
              return SizedBox(
                width: chipWidth,
                child: GestureDetector(
                  onTap: () => onTap(genre.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.redLight : AppTheme.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: isSelected ? [BoxShadow(color: AppTheme.redLight.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))] : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSelected) ...[
                          Icon(Icons.check, color: AppTheme.white, size: 14.w),
                          SizedBox(width: 4.w),
                        ],
                        Flexible(
                          child: Text(
                            genre.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: isSelected ? AppTheme.white : AppTheme.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 60.h;
  @override
  double get minExtent => 60.h;
  @override
  bool shouldRebuild(covariant _GenreNavDelegate oldDelegate) => true;
}

class _MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final String Function(String?) onImage;

  const _MovieGrid({required this.movies, required this.onImage});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return SizedBox(height: 150.h, child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            imageUrl: onImage(movie.posterPath),
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: Colors.white12),
            errorWidget: (_, __, ___) => const Icon(Icons.movie, color: Colors.white24),
          ),
        );
      },
    );
  }
}
