import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/movie.dart';

class RecommendedMovieItem extends StatelessWidget {
  final Movie movie;
  final String imageUrl;
  final VoidCallback? onTap;

  const RecommendedMovieItem({
    super.key,
    required this.movie,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle, 
          border: Border.all(color: Colors.white10),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: Colors.white12),
          errorWidget: (_, __, ___) => const Center(
            child: Icon(Icons.movie, color: Colors.white24),
          ),
        ),
      ),
    );
  }
}
