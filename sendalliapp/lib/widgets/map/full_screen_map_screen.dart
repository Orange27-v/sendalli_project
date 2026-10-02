import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/navigation/app_navigator.dart';
import 'sendalli_map_view.dart';

/// Full-screen map view filling the entire device screen.
///
/// Provides edge-to-edge corridor route tracking, full camera navigation,
/// zoom in/out controls, and a dedicated minimise button to return to the dashboard.
class FullScreenMapScreen extends StatelessWidget {
  final LatLng initialCenter;
  final double zoom;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
  final bool showLiveRider;
  final String? corridorName;

  const FullScreenMapScreen({
    super.key,
    required this.initialCenter,
    required this.zoom,
    this.markers,
    this.polylines,
    this.showLiveRider = true,
    this.corridorName,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppNavigator.safePop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Map fills the entire screen
            Positioned.fill(
              child: SendalliMapView(
                initialCenter: initialCenter,
                zoom: zoom,
                markers: markers,
                polylines: polylines,
                showLiveRider: showLiveRider,
                showControls: true,
                corridorName: corridorName,
                isFullScreen: true,
                onMinimize: () => AppNavigator.safePop(context),
              ),
            ),

            // Top Floating Header Overlay: Corridor badge and minimise pill
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Corridor Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FeatherIcons.navigation, size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          corridorName ?? 'Warri — Effurun Corridor',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Minimise Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: const Key('map_minimize_header_button'),
                      onTap: () => AppNavigator.safePop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border, width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(FeatherIcons.minimize2, size: 14, color: AppColors.textPrimary),
                            const SizedBox(width: 6),
                            Text(
                              'Minimise',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Corridor Status Pill
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Full Screen Corridor View • Live GPS Tracking Active',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
