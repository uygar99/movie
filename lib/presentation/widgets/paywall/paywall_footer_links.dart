import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class PaywallFooterLinks extends StatelessWidget {
  final VoidCallback? onRestorePurchases;
  final VoidCallback? onTermsOfUse;
  final VoidCallback? onPrivacyPolicy;

  const PaywallFooterLinks({
    super.key,
    this.onRestorePurchases,
    this.onTermsOfUse,
    this.onPrivacyPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLink('Terms of Use', onTap: onTermsOfUse),
        _buildLink('Restore Purchase', onTap: onRestorePurchases),
        _buildLink('Privacy Policy', onTap: onPrivacyPolicy),
      ],
    );
  }

  Widget _buildLink(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppTheme.white.withOpacity(0.5), 
          fontSize: 11.sp, 
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
