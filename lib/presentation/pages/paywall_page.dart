import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../stores/paywall_store.dart';
import '../../core/di/injection.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  late final PaywallStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<PaywallStore>();
    _store.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: Observer(
          builder: (_) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    children: [
                      _buildHeader(),
                      SizedBox(height: 30.h),
                      _buildComparisonTable(),
                      SizedBox(height: 30.h),
                      _buildTrialToggle(),
                      SizedBox(height: 24.h),
                      _buildSubscriptionOptions(),
                      SizedBox(height: 24.h),
                      _buildAutoRenewInfo(),
                      SizedBox(height: 24.h),
                      _buildPurchaseButton(),
                      SizedBox(height: 20.h),
                      _buildBottomLinks(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
                if (_store.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator(color: AppTheme.redLight)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'AppName',
          style: GoogleFonts.inter(
            color: AppTheme.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: Icon(Icons.close, color: AppTheme.grayDark, size: 24.w),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonTable() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 50.w,
              child: Text('FREE', 
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppTheme.gray, fontSize: 14.sp, fontWeight: FontWeight.w700)),
            ),
            SizedBox(width: 20.w),
            Container(
              width: 50.w,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.redLight, width: 1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text('PRO',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppTheme.redLight, fontSize: 14.sp, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _buildComparisonRow('Daily Movie Suggestions', true, true),
        _buildComparisonRow('AI-Powered Movie Insights', false, true),
        _buildComparisonRow('Personalized Watchlists', false, true),
        _buildComparisonRow('Ad-Free Experience', false, false),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, bool free, bool pro) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text(feature, style: GoogleFonts.inter(color: AppTheme.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 50.w,
            child: Icon(
              free ? Icons.check_circle : Icons.cancel,
              color: free ? Colors.green : AppTheme.grayDark,
              size: 20.w,
            ),
          ),
          SizedBox(width: 20.w),
          SizedBox(
            width: 50.w,
            child: Icon(
              pro ? Icons.check_circle : Icons.cancel,
              color: pro ? Colors.green : AppTheme.grayDark,
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.redLight.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Enable Free Trial',
            style: GoogleFonts.inter(color: AppTheme.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          Switch(
            value: _store.freeTrialEnabled,
            onChanged: _store.toggleFreeTrial,
            activeColor: AppTheme.white,
            activeTrackColor: AppTheme.redLight,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOptions() {
    // If we have real packages from RC, we use them. Otherwise dummy for design.
    if (_store.packages.isEmpty) {
      return Column(
        children: [
          _buildOption('Weekly', 'Only \$4,99 per week', '\$4,99 / week', false, false),
          SizedBox(height: 12.h),
          _buildOption('Monthly', 'Only \$2,99 per week', '\$11,99 / month', true, false),
          SizedBox(height: 12.h),
          _buildOption('Yearly', 'Only \$0,96 per week', '\$49,99 / year', false, true),
        ],
      );
    }

    return Column(
      children: _store.packages.map((pkg) {
        final isSelected = _store.selectedPackage?.identifier == pkg.identifier;
        final isYearly = pkg.packageType == PackageType.yearly;
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: GestureDetector(
            onTap: () => _store.setSelectedPackage(pkg),
            child: _buildOption(
              pkg.packageType.name.capitalize(),
              'Best Value', // Simple subtitle
              pkg.storeProduct.priceString,
              isSelected,
              isYearly,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOption(String title, String subtitle, String price, bool selected, bool bestValue) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: selected ? AppTheme.redLight : AppTheme.grayDark.withOpacity(0.3), width: selected ? 2 : 1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: selected ? AppTheme.redLight : AppTheme.white, width: 2),
                  color: selected ? AppTheme.redLight : Colors.transparent,
                ),
                child: selected ? Icon(Icons.check, color: AppTheme.white, size: 14.w) : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(color: AppTheme.white, fontSize: 18.sp, fontWeight: FontWeight.w700)),
                    Text(subtitle, style: GoogleFonts.inter(color: AppTheme.grayDark, fontSize: 13.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Text(price, style: GoogleFonts.inter(color: AppTheme.white, fontSize: 18.sp, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        if (bestValue)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.redLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text('Best Value', style: GoogleFonts.inter(color: AppTheme.white, fontSize: 12.sp, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAutoRenewInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, color: Colors.green, size: 16.w),
        SizedBox(width: 8.w),
        Text(
          'Auto Renewable, Cancel Anytime',
          style: GoogleFonts.inter(color: AppTheme.gray, fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton() {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: () async {
          final success = await _store.purchase();
          if (success) {
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.redLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        child: Text(
          'Unlock MovieAI PRO',
          style: GoogleFonts.inter(color: AppTheme.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFooterLink('Terms of Use'),
        _buildFooterLink('Restore Purchase', onTap: _store.restore),
        _buildFooterLink('Privacy Policy'),
      ],
    );
  }

  Widget _buildFooterLink(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.inter(color: AppTheme.grayDark, fontSize: 11.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
