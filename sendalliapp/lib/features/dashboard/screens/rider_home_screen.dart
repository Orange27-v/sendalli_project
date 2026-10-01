import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/storage/session_manager.dart';
import '../../onboarding/screens/welcome_screen.dart';

/// Rider Home Dashboard with On Route toggle & Autonomous Trust Score display.
class RiderHomeScreen extends StatefulWidget {
  final UserProfile user;

  const RiderHomeScreen({super.key, required this.user});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  bool _isOnRoute = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Corridor Hub', style: AppTextStyles.h3),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: () async {
              await SessionManager.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rider Status & Trust Score Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          widget.user.firstName.isNotEmpty ? widget.user.firstName[0] : 'R',
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.fullName, style: AppTextStyles.h3),
                            const SizedBox(height: 2),
                            Text(
                              'Plate: ${widget.user.vehiclePlate ?? "Unregistered"}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      // Autonomous Trust Score Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.eliteGoldLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.eliteGold.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shield_rounded, size: 16, color: AppColors.eliteGold),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.user.trustScore}%',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.eliteGold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Active Corridor', style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text(
                            widget.user.corridor ?? 'Refinery Road — Jakpa',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Pioneer Verified', style: AppTextStyles.caption),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Go On Route Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: _isOnRoute ? AppColors.primaryLight : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isOnRoute ? AppColors.primary : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnRoute ? Icons.radar_rounded : Icons.pause_circle_outline_rounded,
                    color: _isOnRoute ? AppColors.primary : AppColors.textMuted,
                    size: 32,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isOnRoute ? 'You are ON ROUTE' : 'You are OFFLINE',
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          _isOnRoute
                              ? 'Listening for parcel alerts along your road'
                              : 'Toggle on to receive delivery alerts',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _isOnRoute,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryLight,
                    onChanged: (val) {
                      setState(() => _isOnRoute = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            val
                                ? 'Status: ON ROUTE. Broadcast active.'
                                : 'Status: OFFLINE. Alerts paused.',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text('Corridor Delivery Broadcasts', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      _isOnRoute ? Icons.sensors_rounded : Icons.sensors_off_rounded,
                      size: 48,
                      color: _isOnRoute ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isOnRoute ? 'Radar active on corridor' : 'Toggle "On Route" to begin',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Matched parcels will alert with pickup photo and fare.',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
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
