import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/theme/app_theme.dart';

class SubscriptionOptionWidget extends StatelessWidget {
  final Package? package;
  final String title;
  final String subtitle;
  final String weeklyPrice;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback? onTap;

  const SubscriptionOptionWidget({
    super.key,
    this.package,
    required this.title,
    required this.subtitle,
    required this.weeklyPrice,
    required this.isSelected,
    this.isBestValue = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? AppTheme.redLight : const Color(0xFF333333),
                width: 1.5,
              ),
              color: isSelected ? AppTheme.redLight.withOpacity(0.08) : Colors.transparent,
            ),
            child: Row(
              children: [
                _buildRadioIndicator(),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: GoogleFonts.inter(
                          color: AppTheme.white, 
                          fontSize: 18.sp, 
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle, 
                        style: GoogleFonts.inter(
                          color: AppTheme.grayDark, 
                          fontSize: 12.sp, 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  weeklyPrice, 
                  style: GoogleFonts.inter(
                    color: AppTheme.white, 
                    fontSize: 18.sp, 
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (isBestValue) _buildBestValueBadge(),
        ],
      ),
    );
  }

  Widget _buildRadioIndicator() {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppTheme.redLight : const Color(0xFF666666),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: isSelected 
        ? Container(
            decoration: const BoxDecoration(
              color: AppTheme.redLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: AppTheme.white, size: 10.w),
          )
        : null,
    );
  }

  Widget _buildBestValueBadge() {
    return Positioned(
      top: -12.h,
      right: 16.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppTheme.redLight,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          'Best Value', 
          style: GoogleFonts.inter(
            color: AppTheme.white, 
            fontSize: 11.sp, 
            fontWeight: FontWeight.w900, 
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
