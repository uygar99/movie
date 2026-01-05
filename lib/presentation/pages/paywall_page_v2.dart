import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../stores/paywall_store.dart';
import '../../core/di/injection.dart';

class PaywallPageV2 extends StatefulWidget {
  const PaywallPageV2({super.key});

  @override
  State<PaywallPageV2> createState() => _PaywallPageV2State();
}

class _PaywallPageV2State extends State<PaywallPageV2> {
  late final PaywallStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<PaywallStore>();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeaderHeight = screenHeight * 0.5;

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeaderHeight,
            child: Image.asset(
              'assets/paywall_image.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeaderHeight,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    AppTheme.black.withOpacity(0.8),
                    AppTheme.black,
                  ],
                  stops: const [0.0, 0.4, 0.85, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Observer(
              builder: (_) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      _buildHeader(),
                      
                      const Spacer(flex: 2),
                      
                      _buildAppName(),
                      SizedBox(height: 20.h),
                      _buildFeatureList(),
                      
                      const Spacer(flex: 1),
                      
                      _buildSubscriptionOptions(),
                      SizedBox(height: 24.h),
                      _buildAutoRenewInfo(),
                      SizedBox(height: 20.h),
                      _buildPurchaseButton(),
                      SizedBox(height: 16.h),
                      _buildBottomLinks(),
                      SizedBox(height: 12.h),
                    ],
                  ),
                );
              },
            ),
          ),

          if (_store.isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: AppTheme.redLight)),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, color: AppTheme.white, size: 24.w),
          ),
        ),
      ],
    );
  }

  Widget _buildAppName() {
    return Text(
      'Movies',
      style: GoogleFonts.inter(
        color: AppTheme.white,
        fontSize: 34.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.2,
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Daily Movie Suggestions',
      'AI-Powered Movie Insights',
      'Personalized Watchlists',
      'Ad-Free Experience',
    ];

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

  Widget _buildSubscriptionOptions() {
    if (_store.packages.isEmpty) {
      return Column(
        children: [
          _buildOptionItem(null, 'Monthly', '\$11.99/month', '\$2.99 / week', false, false),
          SizedBox(height: 12.h),
          _buildOptionItem(null, 'Yearly', '\$44.99 / year', '\$0.96 / week', true, true),
        ],
      );
    }

    final monthly = _store.packages.firstWhere((p) => p.packageType == PackageType.monthly, orElse: () => _store.packages.first);
    final yearly = _store.packages.firstWhere((p) => p.packageType == PackageType.annual, orElse: () => _store.packages.last);

    return Column(
      children: [
        _buildOptionItem(
          monthly,
          'Monthly',
          '\$${monthly.storeProduct.priceString}/month',
          '\$${(monthly.storeProduct.price / 4).toStringAsFixed(2)} / week',
          _store.selectedPackage?.identifier == monthly.identifier,
          false,
        ),
        SizedBox(height: 12.h),
        _buildOptionItem(
          yearly,
          'Yearly',
          '\$${yearly.storeProduct.priceString}/year',
          '\$${(yearly.storeProduct.price / 52).toStringAsFixed(2)} / week',
          _store.selectedPackage?.identifier == yearly.identifier,
          true,
        ),
      ],
    );
  }

  Widget _buildOptionItem(Package? pkg, String title, String subtitle, String weeklyPrice, bool isSelected, bool isBestValue) {
    return GestureDetector(
      onTap: () {
        if (pkg != null) _store.setSelectedPackage(pkg);
      },
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
                Container(
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
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, 
                        style: GoogleFonts.inter(color: AppTheme.white, fontSize: 18.sp, fontWeight: FontWeight.w700)),
                      Text(subtitle, 
                        style: GoogleFonts.inter(color: AppTheme.grayDark, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Text(weeklyPrice, 
                  style: GoogleFonts.inter(color: AppTheme.white, fontSize: 18.sp, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          if (isBestValue)
            Positioned(
              top: -12.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.redLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('Best Value', 
                  style: GoogleFonts.inter(color: AppTheme.white, fontSize: 11.sp, fontWeight: FontWeight.w900, height: 1.0)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAutoRenewInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: AppTheme.successGreen, size: 18.w),
        SizedBox(width: 8.w),
        Text(
          'Auto Renewable, Cancel Anytime',
          style: GoogleFonts.inter(color: AppTheme.white.withOpacity(0.8), fontSize: 12.sp, fontWeight: FontWeight.w500),
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
          if (success && mounted) {
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.redLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Continue',
              style: GoogleFonts.inter(color: AppTheme.white, fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward, color: AppTheme.white, size: 24.w),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFooterLink('Terms of Use'),
        _buildFooterLink('Restore Purchase', onTap: _store.restorePurchases),
        _buildFooterLink('Privacy Policy'),
      ],
    );
  }

  Widget _buildFooterLink(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.inter(color: AppTheme.white.withOpacity(0.5), fontSize: 11.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
