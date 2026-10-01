import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'welcome_screen.dart';

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

  void _finishWalkthrough() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(FeatherIcons.arrowLeft, size: 20, color: AppColors.textPrimary),
                onPressed: _onPrev,
              )
            : null,
        title: Text(
          'SENDALLI',
          style: AppTextStyles.h2.copyWith(
            fontSize: 20,
            letterSpacing: 2.0,
            color: AppColors.primaryDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _finishWalkthrough,
            child: Text(
              'Skip',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Separated Context Slide
            Expanded(
              child: _buildSlide(_slides[_currentPage]),
            ),

            // Bottom Navigation & Progress Indicator Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentPage == i ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i ? AppColors.primaryDark : AppColors.borderMedium,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Next / Get Started Action
                  ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(110, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_currentPage == _slides.length - 1 ? 'Get Started' : 'Next'),
                        const SizedBox(width: 6),
                        const Icon(FeatherIcons.arrowRight, size: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(_WalkthroughSlideData slide, {Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Context Hero SVG
          SizedBox(
            height: 140,
            child: SvgPicture.asset(
              slide.svgPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),

          // Context Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              slide.badge,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Context Headline
          Text(
            slide.title,
            style: AppTextStyles.h1.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Context Subtitle
          Text(
            slide.description,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Feature Highlight Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.borderMedium, width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FeatherIcons.checkCircle, size: 14, color: AppColors.success),
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
