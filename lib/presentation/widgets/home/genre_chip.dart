import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/genre.dart';

class GenreChip extends StatelessWidget {
  final Genre genre;
  final bool isSelected;
  final VoidCallback? onTap;
  final GlobalKey? itemKey;

  const GenreChip({
    super.key,
    required this.genre,
    required this.isSelected,
    this.onTap,
    this.itemKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: itemKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 110.w,
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.redLight : Colors.white10,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: Text(
          genre.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: AppTheme.white,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
