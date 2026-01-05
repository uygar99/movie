import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class FeatureListWidget extends StatelessWidget {
  final List<String> features;

  const FeatureListWidget({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features.map((f) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: AppTheme.white, size: 20.w),
            SizedBox(width: 12.w),
            Text(
              f,
              style: GoogleFonts.inter(
                color: AppTheme.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
