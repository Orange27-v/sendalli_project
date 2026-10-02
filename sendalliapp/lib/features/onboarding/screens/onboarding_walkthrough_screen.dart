import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/navigation/app_navigator.dart';

/// Full-featured, multi-screen Onboarding Walkthrough.
/// Each business model context is separated into its own full, dedicated screen:
/// 1. Senders & Merchants (take-out-boxes.svg)
/// 2. Keke Transit Fleet (logistics.svg)
/// 3. Roadside Drop Hubs (order-delivered.svg)
/// 4. Receiver Live Tracking (delivery-location.svg)
class OnboardingWalkthroughScreen extends StatefulWidget {
  const OnboardingWalkthroughScreen({super.key});

  @override
  State<OnboardingWalkthroughScreen> createState() => _OnboardingWalkthroughScreenState();
}

class _OnboardingWalkthroughScreenState extends State<OnboardingWalkthroughScreen> {
  int _currentPage = 0;

  final List<_WalkthroughSlideData> _slides = const [
    _WalkthroughSlideData(
      badge: 'CORRIDOR PARCEL NETWORK',
      title: 'Move Parcels Across Warri & Effurun',
      description:
          'Eliminate exorbitant courier fees. Send goods, boutique orders, and documents along fixed transit corridors for a flat, predictable fare.',
      svgPath: 'assets/svg/take-out-boxes.svg',
      highlightTag: 'Flat ₦1,200 Corridor Rate',
    ),
    _WalkthroughSlideData(
      badge: 'ROUTE-POOLED TRANSIT',
      title: 'Tricycle Drivers Earn on Passenger Routes',
      description:
          'Commercial keke drivers carry parcels alongside passengers along Refinery, PTI, and Airport roads. Zero detours, extra income.',
      svgPath: 'assets/svg/logistics.svg',
      highlightTag: 'Earn ₦800 per delivery leg',
    ),
    _WalkthroughSlideData(
      badge: 'COMMUNITY MICRO-HUBS',
      title: 'Roadside Shops Earn As Verified Drop Hubs',
      description:
          'Roadside pharmacies, supermarkets, and provision stores safely hold parcels for convenient receiver collection.',
      svgPath: 'assets/svg/order-delivered.svg',
      highlightTag: '₦500 per parcel stored',
    ),
    _WalkthroughSlideData(
      badge: 'ZERO-LOGIN TRACKING',
      title: 'Instant Receiver Handover with PIN',
      description:
          'Receivers track arrivals in real-time with countdown timers. Hand over safely using high-contrast 6-digit release codes.',
      svgPath: 'assets/svg/delivery-location.svg',
      highlightTag: 'No account needed for receivers',
    ),
  ];

  void _safeExit() {
    AppNavigator.safePop(context);
  }

  void _finishWalkthrough() {
    _safeExit();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      setState(() => _currentPage++);
    } else {
      _finishWalkthrough();
    }
  }

  void _onPrev() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentPage > 0) {
          _onPrev();
        } else {
          _safeExit();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(FeatherIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
            onPressed: () {
              if (_currentPage > 0) {
                _onPrev();
              } else {
                _safeExit();
              }
            },
          ),
          title: Text(
            'SENDALLI',
            style: AppTextStyles.h2.copyWith(
              fontSize: 18,
              letterSpacing: 2.0,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: _finishWalkthrough,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.35), width: 1.0),
                ),
                child: Text(
                  'Skip',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              // Separated Context Slide
              Expanded(
                child: _buildSlide(_slides[_currentPage]),
              ),

              // Dot Indicators (Dark contrast pills/dots on vibrant lime)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == i ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _currentPage == i ? AppColors.textPrimary : AppColors.textPrimary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Full-Width Contrast Dark Button on Lime Background
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Bottom pill tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.25), width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FeatherIcons.globe, size: 12, color: AppColors.textPrimary),
                    const SizedBox(width: 6),
                    Text(
                      'Warri & Effurun Transit Corridors',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    ),);
  }

  Widget _buildSlide(_WalkthroughSlideData slide, {Key? key}) {
    return SingleChildScrollView(
      key: key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),

          // Hero Artwork in soft circular contrast container
          Container(
            width: 220,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.45),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.08), width: 1.0),
            ),
            padding: const EdgeInsets.all(22),
            child: Center(
              child: SvgPicture.asset(
                slide.svgPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Context Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              slide.badge,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Context Headline
          Text(
            slide.title,
            style: AppTextStyles.h1.copyWith(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Context Subtitle
          Text(
            slide.description,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textPrimary.withValues(alpha: 0.85),
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Feature Highlight Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.15), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FeatherIcons.checkCircle, size: 14, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text(
                  slide.highlightTag,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _WalkthroughSlideData {
  final String badge;
  final String title;
  final String description;
  final String svgPath;
  final String highlightTag;

  const _WalkthroughSlideData({
    required this.badge,
    required this.title,
    required this.description,
    required this.svgPath,
    required this.highlightTag,
  });
}
