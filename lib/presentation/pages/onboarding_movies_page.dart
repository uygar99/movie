import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../core/di/injection.dart';
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
    _store.loadMovies();
    
    // Tasarım: 180w + 15px boşluk = 195px slot.
    // ViewportFraction: 195 / 375 = 0.52
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. THE DRUM WHEEL
          Positioned.fill(
            child: Observer(
              builder: (_) {
                if (_store.movies.isEmpty && _store.isLoadingMovies) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white24));
                }
                return PageView.builder(
                  controller: _pageController,
                  itemCount: _store.movies.length,
                  pageSnapping: false, // Serbest akış
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

          // 2. TOP BLACK MASK (DÜZGÜN KAVİS)
          // Ekranın üst kısmını kesen devasa bir tam daire.
          Positioned(
            top: -380.h,
            left: -100.w,
            right: -100.w,
            child: IgnorePointer(
              child: Container(
                height: 500.h,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // 3. BOTTOM BLACK MASK (DÜZGÜN KAVİS)
          Positioned(
            bottom: -380.h,
            left: -100.w,
            right: -100.w,
            child: IgnorePointer(
              child: Container(
                height: 500.h,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // 4. HEADER CONTENT
          Positioned(
            top: 60.h,
            left: 20.w,
            right: 20.w,
            child: Observer(
              builder: (_) {
                final hasSelection = _store.selectedMovieIds.isNotEmpty;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSelection ? 'Keep Going 👍' : 'Welcome',
                      style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Choose your 3 favorite movies',
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 18.sp),
                    ),
                  ],
                );
              },
            ),
          ),

          // 5. FOOTER BUTTON
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: Observer(
              builder: (_) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _store.canContinueFromMovies 
                      ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OnboardingGenresPage(store: _store)))
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC3333),
                      disabledBackgroundColor: const Color(0xFFCC3333).withOpacity(0.15),
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    ),
                    child: Text('Continue', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
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
        
        // --- KUSURSUZ YAPIŞIK SİLİNDİR MATEMATİĞİ ---
        // 180w + 15px = 195.0 total slot.
        const double slotWidth = 195.0;
        const double radius = 400.0;
        
        // Açı = Yay uzunluğu / Yarıçap
        final double angle = (diff * slotWidth) / radius;

        // Transformasyon:
        // PageView'in varsayılan yatay yerleşimini (diff * slotWidth) dengeleyip,
        // Kartı dairesel yay (sin/cos) üzerindeki gerçek noktasına çekiyoruz.
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(
              (math.sin(angle) * radius) - (diff * slotWidth), // Yatay düzeltme
              0.0, 
              (math.cos(angle) - 1.0) * radius // Derinlik (Z)
            )
            ..rotateY(angle),
          child: Center(
            child: GestureDetector(
              onTap: () => store.toggleMovieSelection(movie.id),
              child: _CardView(movie: movie, store: store, imageUrl: imageUrl),
            ),
          ),
        );
      },
    );
  }
}

class _CardView extends StatelessWidget {
  final Movie movie;
  final OnboardingStore store;
  final String imageUrl;

  const _CardView({required this.movie, required this.store, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isSelected = store.selectedMovieIds.contains(movie.id);

    return Container(
      width: 180.w, // TAM 180w
      height: 252.h, // TAM 252h
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isSelected ? const Color(0xFFCC3333) : Colors.white10,
          width: isSelected ? 4.w : 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(color: Colors.white12),
            ),
            if (isSelected) Container(color: Colors.white24),
            if (isSelected)
              Positioned(
                bottom: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(color: Color(0xFFCC3333), shape: BoxShape.circle),
                  child: Icon(Icons.check, color: Colors.white, size: 16.w),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
