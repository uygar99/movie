import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../stores/environment_store.dart';

class EnvironmentSelectorPage extends StatelessWidget {
  const EnvironmentSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final envStore = getIt<EnvironmentStore>();

    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '🔧 Developer Options',
          style: GoogleFonts.inter(
            color: AppTheme.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Environment',
              style: GoogleFonts.inter(
                color: AppTheme.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Choose the environment for API calls and features',
              style: GoogleFonts.inter(
                color: AppTheme.grayDark,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 32.h),
            Observer(
              builder: (_) => Column(
                children: AppEnvironment.values.map((env) {
                  final isSelected = envStore.currentEnvironment == env;
                  return _buildEnvironmentOption(
                    context,
                    env,
                    isSelected,
                    () => _onEnvironmentSelected(context, envStore, env),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            Observer(
              builder: (_) => Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.grayDark.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppTheme.grayDark.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.grayDark, size: 18.w),
                        SizedBox(width: 8.w),
                        Text(
                          'Current Config',
                          style: GoogleFonts.inter(
                            color: AppTheme.grayDark,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildInfoRow('Environment', envStore.currentEnvironment.displayName),
                    _buildInfoRow('Debug Mode', envStore.isDebugMode ? 'Enabled' : 'Disabled'),
                    _buildInfoRow('API', 'TMDB v3'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentOption(
    BuildContext context,
    AppEnvironment env,
    bool isSelected,
    VoidCallback onTap,
  ) {
    Color accentColor;
    IconData icon;
    
    switch (env) {
      case AppEnvironment.test:
        accentColor = Colors.orange;
        icon = Icons.bug_report;
        break;
      case AppEnvironment.beta:
        accentColor = Colors.purple;
        icon = Icons.science;
        break;
      case AppEnvironment.prod:
        accentColor = Colors.green;
        icon = Icons.rocket_launch;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accentColor : AppTheme.grayDark.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: accentColor, size: 24.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    env.displayName,
                    style: GoogleFonts.inter(
                      color: AppTheme.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    env.description,
                    style: GoogleFonts.inter(
                      color: AppTheme.grayDark,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: accentColor, size: 24.w),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.grayDark,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppTheme.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _onEnvironmentSelected(BuildContext context, EnvironmentStore store, AppEnvironment env) {
    store.setEnvironment(env);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Environment changed to ${env.displayName}',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.redLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
