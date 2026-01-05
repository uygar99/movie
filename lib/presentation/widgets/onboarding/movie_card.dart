import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/movie.dart';
import '../../stores/onboarding_store.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final OnboardingStore store;
  final String imageUrl;

  const MovieCard({
    super.key,
    required this.movie,
    required this.store,
    required this.imageUrl,
  });

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
                
                if (isSelected)
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [
                            const Color(0x00CB2C2C),
                            AppTheme.selectionInsetRed,
                          ],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                    ),
                  ),

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
