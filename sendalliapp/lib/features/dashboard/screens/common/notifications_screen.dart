import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/user_role.dart';
import '../../../../widgets/custom_app_bar.dart';

/// Role-aware Logistics Notification Model
class LogisticsNotification {
  final String id;
  final String title;
  final String body;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
  final bool isUnread;
  final String? actionTag;

  const LogisticsNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    this.isUnread = false,
    this.actionTag,
  });
}

/// Dynamic, role-aware Notifications Screen for Sendalli corridor logistics.
class NotificationsScreen extends StatefulWidget {
  final UserProfile user;

  const NotificationsScreen({super.key, required this.user});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTabIndex = 0;
  late List<LogisticsNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _generateRoleNotifications(widget.user.role);
  }

  List<LogisticsNotification> _generateRoleNotifications(UserRole role) {
    switch (role) {
      case UserRole.rider:
        return [
          const LogisticsNotification(
            id: 'n_r1',
            title: 'New Corridor Trip Nearby',
            body: 'Package #SND-WAR-8492 ready at PTI Junction. Payout: ₦1,800 to Jakpa.',
            timestamp: '2 mins ago',
            icon: FeatherIcons.navigation,
            iconColor: AppColors.primary,
            isUnread: true,
            actionTag: 'Accept Trip',
          ),
          const LogisticsNotification(
            id: 'n_r2',
            title: 'Trust Score Milestone (+2 pts)',
            body: 'Excellent compliance! 1-minute roadside handoff completed with zero delay.',
            timestamp: '45 mins ago',
            icon: FeatherIcons.award,
            iconColor: Color(0xFFF59E0B),
            isUnread: true,
            actionTag: 'View Score',
          ),
          const LogisticsNotification(
            id: 'n_r3',
            title: 'Same-Day Payout Settled',
            body: '₦4,200 transferred to your GTBank account via Paystack Transfer.',
            timestamp: '3 hrs ago',
            icon: FeatherIcons.checkCircle,
            iconColor: AppColors.primary,
            isUnread: false,
          ),
          const LogisticsNotification(
            id: 'n_r4',
            title: 'Corridor Traffic Advisory',
            body: 'Slow movement near Effurun Roundabout. Recommended alternate route via Refinery link.',
            timestamp: 'Yesterday',
            icon: FeatherIcons.alertTriangle,
            iconColor: Color(0xFFEF4444),
            isUnread: false,
          ),
        ];
      case UserRole.sender:
        return [
          const LogisticsNotification(
            id: 'n_s1',
            title: 'Parcel In Transit (#SND-WAR-8492)',
            body: 'Rider Diran Olakunle has picked up your package. Heading to Effurun Roundabout.',
            timestamp: '5 mins ago',
            icon: FeatherIcons.truck,
            iconColor: AppColors.primary,
            isUnread: true,
            actionTag: 'Track Live',
          ),
          const LogisticsNotification(
            id: 'n_s2',
            title: '100% Escrow Protection Active',
            body: '₦4,800 safely locked in escrow until recipient confirms with 6-digit PIN.',
            timestamp: '15 mins ago',
            icon: FeatherIcons.shield,
            iconColor: Color(0xFF10B981),
            isUnread: true,
          ),
          const LogisticsNotification(
            id: 'n_s3',
            title: 'Successful Handover & Release',
            body: 'Package #SND-WAR-7102 was safely delivered to Jakpa Junction.',
            timestamp: 'Yesterday',
            icon: FeatherIcons.checkCircle,
            iconColor: AppColors.primary,
            isUnread: false,
          ),
          const LogisticsNotification(
            id: 'n_s4',
            title: 'Drop Hub Opportunity',
            body: 'Earn extra income! Turn your shop into a Sendalli corridor holding hub.',
            timestamp: '2 days ago',
            icon: FeatherIcons.home,
            iconColor: Color(0xFF6366F1),
            isUnread: false,
            actionTag: 'Apply Now',
          ),
        ];
      case UserRole.receiver:
        return [
          const LogisticsNotification(
            id: 'n_rec1',
            title: 'Rider Approaching (ETA 4 Mins)',
            body: 'Rider Diran is near PTI Junction landmark. Please proceed to the roadside.',
            timestamp: 'Just now',
            icon: FeatherIcons.navigation,
            iconColor: AppColors.primary,
            isUnread: true,
            actionTag: 'Open Map',
          ),
          const LogisticsNotification(
            id: 'n_rec2',
            title: '6-Digit Handover Code: 849 201',
            body: 'Inspect parcel exterior before giving this code to the rider to release.',
            timestamp: '8 mins ago',
            icon: FeatherIcons.key,
            iconColor: Color(0xFFF59E0B),
            isUnread: true,
          ),
          const LogisticsNotification(
            id: 'n_rec3',
            title: '1-Minute Roadside Window Active',
            body: 'Rider has arrived at the corridor stop. If unavailable, 1-tap Hub diversion is ready.',
            timestamp: '15 mins ago',
            icon: FeatherIcons.clock,
            iconColor: Color(0xFFEF4444),
            isUnread: false,
            actionTag: 'Reroute to Hub',
          ),
          const LogisticsNotification(
            id: 'n_rec4',
            title: 'Handover Confirmed',
            body: 'Parcel #SND-WAR-6291 collected. 30-minute dispute window open.',
            timestamp: 'Yesterday',
            icon: FeatherIcons.checkCircle,
            iconColor: AppColors.primary,
            isUnread: false,
          ),
        ];
      case UserRole.hub:
        return [
          const LogisticsNotification(
            id: 'n_h1',
            title: 'Incoming Diversion (#SND-WAR-8492)',
            body: 'Roadside receiver missed handoff. Rider en route to your store for custody.',
            timestamp: 'Just now',
            icon: FeatherIcons.download,
            iconColor: AppColors.primary,
            isUnread: true,
            actionTag: 'Prepare Intake',
          ),
          const LogisticsNotification(
            id: 'n_h2',
            title: 'Custody Fee Credited (+₦500)',
            body: '₦500 holding fee successfully credited to your ledger for package #SND-WAR-8492.',
            timestamp: '1 hr ago',
            icon: FeatherIcons.dollarSign,
            iconColor: Color(0xFF10B981),
            isUnread: true,
          ),
          const LogisticsNotification(
            id: 'n_h3',
            title: 'Customer PIN Handover Verified',
            body: 'Package released to recipient (+234 803 000 1234). Holding cycle complete.',
            timestamp: '4 hrs ago',
            icon: FeatherIcons.checkCircle,
            iconColor: AppColors.primary,
            isUnread: false,
          ),
          const LogisticsNotification(
            id: 'n_h4',
            title: 'Operating Hours Active',
            body: 'Your hub is currently open for corridor drop-offs (8:00 AM – 7:00 PM).',
            timestamp: 'Today, 8:00 AM',
            icon: FeatherIcons.clock,
            iconColor: Color(0xFF6366F1),
            isUnread: false,
          ),
        ];
    }
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) {
        return LogisticsNotification(
          id: n.id,
          title: n.title,
          body: n.body,
          timestamp: n.timestamp,
          icon: n.icon,
          iconColor: n.iconColor,
          isUnread: false,
          actionTag: n.actionTag,
        );
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _notifications.where((n) {
      if (_selectedTabIndex == 1) return n.isUnread;
      if (_selectedTabIndex == 2) return n.actionTag != null;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.check, size: 18, color: AppColors.textInverse),
            tooltip: 'Mark All Read',
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Filter Pills Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surface,
              child: Row(
                children: [
                  _buildTabPill(0, 'All (${_notifications.length})'),
                  const SizedBox(width: 8),
                  _buildTabPill(1, 'Unread (${_notifications.where((n) => n.isUnread).length})'),
                  const SizedBox(width: 8),
                  _buildTabPill(2, 'Actionable'),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),

            // Notification List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(FeatherIcons.bellOff, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text('No notifications found', style: AppTextStyles.h3),
                          const SizedBox(height: 4),
                          Text('You are all caught up on corridor activity.', style: AppTextStyles.caption),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: AppDimens.screenInsets,
                      itemCount: filtered.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _buildNotificationCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: AppDimens.borderWidth,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(LogisticsNotification item) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: item.isUnread ? const Color(0xFFF0FDF4) : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isUnread ? AppColors.primary.withValues(alpha: 0.35) : AppColors.border,
          width: item.isUnread ? AppDimens.borderWidthMedium : AppDimens.borderWidth,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 18, color: item.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: item.isUnread ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (item.isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.timestamp,
                      style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                    if (item.actionTag != null)
                      Text(
                        item.actionTag!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
