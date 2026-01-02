import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    
    // Kartların büyük ve yapışık olması için yüksek viewportFraction
    _pageController = PageController(
      viewportFraction: 0.85, 
      initialPage: 0,
    );
    
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        _store.updateWheelPosition(_pageController.page ?? 0);
        
        if ((_pageController.page ?? 0) >= _store.movies.length - 4) {
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
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            // Minimal Header
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: _HeaderWidget(),
            ),

            // The Grand Convex Wheel
            Expanded(
              child: Observer(
                builder: (_) {
                  if (_store.movies.isEmpty && _store.isLoadingMovies) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white12));
                  }

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: _store.movies.length,
                    clipBehavior: Clip.none, // Yan kartların kesilmemesi için
                    itemBuilder: (context, index) {
                      return _DrumItem(
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

            // Footer
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _FooterWidget(store: _store),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrumItem extends StatelessWidget {
  final int index;
  final Movie movie;
  final OnboardingStore store;
  final String imageUrl;

  const _DrumItem({
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
        
        // --- CONVEX DRUM MATEMATİĞİ ---
        // Çok küçük bir açı (sapma) kullanarak kartları birbirine yapıştırıyoruz
        final double angle = diff * 0.25; 
        
        final double radius = 400.0;
        final double translateZ = (math.cos(angle) - 1.0) * radius;
        final double translateX = math.sin(angle) * radius;
        final double rotationY = angle;

        final bool isSelected = store.selectedMovieIds.contains(movie.id);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0008) // Yumuşak perspektif
            ..translate(translateX, 0.0, translateZ)
            ..rotateY(rotationY),
          child: Center(
            child: GestureDetector(
              onTap: () => store.toggleMovieSelection(movie.id),
              child: ClipPath(
                clipper: _DrumClipper(diff: diff),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Büyük kartlar
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFCC3333) : Colors.white10,
                      width: isSelected ? 4 : 1,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(Icons.movie, color: Colors.white10),
                      ),
                      
                      // Renkli Overlay (Seçili halde pembe/beyaz geçişi)
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.35),
                                Colors.red.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),

                      // Checkmark
                      if (isSelected)
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFCC3333),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 22),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Tasarımdaki kavisli üst ve alt kenarları sağlayan Clipper
class _DrumClipper extends CustomClipper<Path> {
  final double diff;
  _DrumClipper({required this.diff});

  @override
  Path getClip(Size size) {
    final path = Path();
    // Kavis miktarı (Cylindrical effect)
    final double arcHeight = 35.0; 
    
    path.moveTo(0, arcHeight);
    
    // Üst Yay
    path.quadraticBezierTo(size.width / 2, -arcHeight/2, size.width, arcHeight);
    
    path.lineTo(size.width, size.height - arcHeight);
    
    // Alt Yay
    path.quadraticBezierTo(size.width / 2, size.height + arcHeight/2, 0, size.height - arcHeight);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_DrumClipper oldClipper) => oldClipper.diff != diff;
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    final store = getIt<OnboardingStore>();
    return Observer(
      builder: (_) {
        final hasSelection = store.selectedMovieIds.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasSelection ? 'Continue to next step 👉' : 'Welcome',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Choose your 3 favorite movies',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 18),
            ),
          ],
        );
      },
    );
  }
}

class _FooterWidget extends StatelessWidget {
  final OnboardingStore store;
  const _FooterWidget({required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: store.canContinueFromMovies 
              ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OnboardingGenresPage(store: store)))
              : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCC3333),
              disabledBackgroundColor: const Color(0xFFCC3333).withOpacity(0.15),
              padding: const EdgeInsets.symmetric(vertical: 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        );
      },
    );
  }
}
