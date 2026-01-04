import 'package:flutter/cupertino.dart';
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

class _PaywallPageState extends State<PaywallPage> with TickerProviderStateMixin {
  late final PaywallStore _store;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _store = getIt<PaywallStore>();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Listen to store changes to start/stop pulse
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    children: [
                      _buildHeader(),
                      SizedBox(height: 20.h),
                      _buildComparisonTable(),
                      SizedBox(height: 20.h),
                      _buildTrialToggle(),
                      SizedBox(height: 20.h),
                      _buildSubscriptionOptions(),
                      SizedBox(height: 16.h),
                      _buildAutoRenewInfo(),
                      SizedBox(height: 16.h),
                      _buildPurchaseButton(),
                      SizedBox(height: 20.h),
                      _buildBottomLinks(),
                      SizedBox(height: 10.h),
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
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Movie',
            style: GoogleFonts.inter(
              color: AppTheme.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.all(8.w), // Better touch target
                child: Icon(Icons.close, color: AppTheme.white, size: 24.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    int proTickCount = 0;
    
    if (_store.freeTrialEnabled) {
      proTickCount = 4;
    } else {
      final pkgType = _store.selectedPackage?.packageType;
      if (pkgType == PackageType.weekly) {
        proTickCount = 2;
      } else if (pkgType == PackageType.monthly) {
        proTickCount = 3;
      } else if (pkgType == PackageType.annual) {
        proTickCount = 4;
      } else {
        proTickCount = 3; 
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            // Header Row inside Stack
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 50.w,
                  child: Text('FREE', 
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: AppTheme.white, fontSize: 13.sp, fontWeight: FontWeight.w700)),
                ),
                SizedBox(width: 20.w),
                SizedBox(
                  width: 60.w,
                  height: 24.h, // Fixed height for header alignment
                  child: Center(
                    child: Text('PRO',
                      style: GoogleFonts.inter(color: AppTheme.white, fontSize: 13.sp, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildComparisonRow('Daily Movie Suggestions', true, proTickCount >= 1),
            _buildComparisonRow('AI-Powered Movie Insights', false, proTickCount >= 2),
            _buildComparisonRow('Personalized Watchlists', false, proTickCount >= 3),
            _buildComparisonRow('Ad-Free Experience', false, proTickCount >= 4),
          ],
        ),
        // Continuous Red border around the PRO column
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 60.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.redLight, width: 1.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, bool free, bool pro) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(feature, 
              style: GoogleFonts.inter(color: AppTheme.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 50.w,
            child: Center(child: _AnimatedIcon(isActive: true, isSuccess: free)),
          ),
          SizedBox(width: 20.w),
          SizedBox(
            width: 60.w,
            child: Center(child: _AnimatedIcon(isActive: true, isSuccess: pro)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.redLight, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
        color: AppTheme.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Enable Free Trial',
            style: GoogleFonts.inter(color: AppTheme.white, fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          CupertinoSwitch(
            value: _store.freeTrialEnabled,
            onChanged: _store.toggleFreeTrial,
            activeColor: AppTheme.successGreen,
            trackColor: const Color(0xFF333333),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOptions() {
    if (_store.packages.isEmpty) {
      return Column(
        children: [
          _buildOptionItem(null, 'Weekly', 'Only \$4.99 per week', '\$4.99 / week', false, false),
          SizedBox(height: 10.h),
          _buildOptionItem(null, 'Monthly', 'Only \$2.99 per week', '\$11.99 / month', false, false),
          SizedBox(height: 10.h),
          _buildOptionItem(null, 'Yearly', 'Only \$0.96 per week', '\$49.99 / year', true, true),
        ],
      );
    }

    return Column(
      children: _store.packages.map((pkg) {
        final isSelected = _store.selectedPackage?.identifier == pkg.identifier;
        final isYearly = pkg.packageType == PackageType.annual;
        
        String priceText = pkg.storeProduct.priceString;
        String suffix = '';
        String subtitle = 'Subscription plan';

        if (pkg.packageType == PackageType.weekly) {
          suffix = ' / week';
          subtitle = 'Only \$${pkg.storeProduct.price.toStringAsFixed(2)} per week';
        } else if (pkg.packageType == PackageType.monthly) {
          suffix = ' / month';
          subtitle = 'Only \$${(pkg.storeProduct.price / 4).toStringAsFixed(2)} per week';
        } else if (pkg.packageType == PackageType.annual) {
          suffix = ' / year';
          subtitle = 'Only \$${(pkg.storeProduct.price / 52).toStringAsFixed(2)} per week';
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildOptionItem(
            pkg,
            pkg.packageType.name.capitalize(),
            subtitle,
            '${pkg.storeProduct.priceString}$suffix',
            isSelected,
            isYearly,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOptionItem(Package? pkg, String title, String subtitle, String price, bool isSelected, bool isBestValue) {
    return GestureDetector(
      onTap: () {
        if (pkg != null) _store.setSelectedPackage(pkg);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? AppTheme.redLight : const Color(0xFF333333), width: 1.5),
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? AppTheme.redLight : AppTheme.white, width: 2),
                    color: isSelected ? AppTheme.redLight : Colors.transparent,
                  ),
                  child: isSelected 
                    ? Icon(Icons.check, color: AppTheme.white, size: 12.w)
                    : null,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, 
                        style: GoogleFonts.inter(color: AppTheme.white, fontSize: 16.sp, fontWeight: FontWeight.w700)),
                      Text(subtitle, 
                        style: GoogleFonts.inter(color: AppTheme.grayDark, fontSize: 11.sp, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Text(price, 
                  style: GoogleFonts.inter(color: AppTheme.white, fontSize: 16.sp, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          if (isBestValue)
            Positioned(
              top: -8.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.redLight,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text('Best Value', 
                    style: GoogleFonts.inter(color: AppTheme.white, fontSize: 11.sp, fontWeight: FontWeight.w900)),
                ),
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
        Icon(Icons.check_circle, color: AppTheme.successGreen, size: 16.w),
        SizedBox(width: 8.w),
        Text(
          'Auto Renewable, Cancel Anytime',
          style: GoogleFonts.inter(color: AppTheme.white.withOpacity(0.7), fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton() {
    return Observer(
      builder: (_) {
        Widget button = SizedBox(
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
              padding: EdgeInsets.zero,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _store.freeTrialEnabled ? '3 Days Free' : 'Unlock Movie PRO',
                  style: GoogleFonts.inter(color: AppTheme.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
                ),
                if (_store.freeTrialEnabled)
                  Text(
                    'No Payment Now',
                    style: GoogleFonts.inter(color: AppTheme.white.withOpacity(0.9), fontSize: 13.sp, fontWeight: FontWeight.w700),
                  ),
              ],
            ),
          ),
        );

        if (_store.freeTrialEnabled) {
          return AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scaleX: _pulseAnimation.value,
                child: child,
              );
            },
            child: button,
          );
        }
        return button;
      },
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
        style: GoogleFonts.inter(color: AppTheme.white.withOpacity(0.6), fontSize: 10.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _AnimatedIcon extends StatefulWidget {
  final bool isActive;
  final bool isSuccess;

  const _AnimatedIcon({required this.isActive, required this.isSuccess});

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    if (widget.isActive) _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.forward();
    } else if (!widget.isActive) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        widget.isSuccess ? Icons.check_circle : Icons.cancel,
        color: widget.isSuccess ? AppTheme.successGreen : AppTheme.white,
        size: 20.w,
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
