import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../core/constants/app_text_styles.dart';
import '../core/models/user_profile.dart';
import '../core/models/user_role.dart';
import '../core/navigation/app_navigator.dart';
import '../core/theme/app_theme.dart';
import '../features/dashboard/screens/common/notifications_screen.dart';
import '../features/dashboard/screens/common/profile_screen.dart';
import '../features/dashboard/screens/common/settings_screen.dart';

/// Standardized fixed app header across all Sendalli dashboards (Rider, Sender, Receiver, Hub).
///
/// Features:
/// 1. Tappable User Avatar and greeting properly docked to the far left.
/// 2. Compact typography defined centrally in the theme tokens (AppTheme.headerGreeting & headerSubtitle).
/// 3. Notification bell icon with unread badge indicator on the right.
/// 4. Settings gear icon on the right for security and corridor preferences.
/// 5. Clean Sendalli brand green (#009944) with crisp white typography and icons.
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserProfile user;
  final String? title;
  final String? subtitle;
  final bool showLeading;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? extraActions;
  final bool hasUnreadNotifications;

  const DashboardAppBar({
    super.key,
    required this.user,
    this.title,
    this.subtitle,
    this.showLeading = false,
    this.onLeadingPressed,
    this.extraActions,
    this.hasUnreadNotifications = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String get _effectiveTitle {
    if (title != null && title!.isNotEmpty) return title!;
    final name = user.firstName.trim();
    return name.isNotEmpty ? 'Hello $name' : 'Hello there';
  }

  String get _effectiveSubtitle {
    if (subtitle != null && subtitle!.isNotEmpty) return subtitle!;
    switch (user.role) {
      case UserRole.rider:
        return user.corridor ?? 'Corridor Active';
      case UserRole.sender:
        return user.shopName ?? 'Sendalli Merchant';
      case UserRole.receiver:
        return user.id.startsWith('GUEST') ? 'Roadside Guest' : 'Verified Recipient';
      case UserRole.hub:
        return user.unionPark ?? 'Drop Hub Custody';
    }
  }

  String get _avatarInitial {
    if (user.firstName.isNotEmpty) return user.firstName[0].toUpperCase();
    if (user.fullName.isNotEmpty) return user.fullName[0].toUpperCase();
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textInverse,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      leadingWidth: showLeading ? 48 : null,
      leading: showLeading
          ? IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, size: 20, color: AppColors.textInverse),
              tooltip: 'Back',
              onPressed: () {
                if (onLeadingPressed != null) {
                  onLeadingPressed!();
                } else {
                  AppNavigator.safePop(context);
                }
              },
            )
          : null,
      titleSpacing: showLeading ? 4 : 16,
      title: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User Avatar properly aligned to the left
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    _avatarInitial,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // User Name & Corridor / Role subtitle with reduced font size defined in theme
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _effectiveTitle,
                      style: AppTheme.headerGreeting,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _effectiveSubtitle,
                      style: AppTheme.headerSubtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (extraActions != null) ...extraActions!,
        // Notification Bell with unread badge
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(FeatherIcons.bell, size: 20, color: AppColors.textInverse),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NotificationsScreen(user: user)),
                );
              },
            ),
            if (hasUnreadNotifications)
              Positioned(
                top: 11,
                right: 11,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
        // Settings Icon
        IconButton(
          icon: const Icon(FeatherIcons.settings, size: 20, color: AppColors.textInverse),
          tooltip: 'Settings',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SettingsScreen(user: user)),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
