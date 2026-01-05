import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: AppTheme.white, 
          fontSize: 24.sp, 
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
