import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../../domain/entities/movie.dart';
import '../../stores/onboarding_store.dart';
import 'drum_clipper.dart';
import 'movie_card.dart';

class WheelCard extends StatelessWidget {
  final int index;
  final Movie movie;
  final OnboardingStore store;
  final String imageUrl;

  const WheelCard({
    super.key,
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
        
        const double slotWidth = 195.0;
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
                clipper: DrumClipper(
                  globalAngle: angle,
                  radius: radius,
                  cardWidth: 180.w,
                ),
                child: MovieCard(movie: movie, store: store, imageUrl: imageUrl),
              ),
            ),
          ),
        );
      },
    );
  }
}
