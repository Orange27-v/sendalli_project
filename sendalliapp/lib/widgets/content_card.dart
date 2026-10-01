import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'settings_kit.dart';

/// Reusable modular Content Card adapted from Nelo's ContentCard architecture.
///
/// Wraps any section content with a clean white card, optional section header,
/// badge counter, optional custom header actions, and "View all" / "More" link.
class ContentCard extends StatelessWidget {
  final String? title;
  final int? badgeCount;
  final List<Widget>? headerActions;
  final VoidCallback? onViewAll;
  final String viewAllLabel;
  final Widget child;
  final bool expandChild;
  final EdgeInsetsGeometry padding;

  const ContentCard({
    super.key,
    this.title,
    this.badgeCount,
    this.headerActions,
    this.onViewAll,
    this.viewAllLabel = 'More',
    required this.child,
    this.expandChild = false,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? AppColors.surface;
    final borderRadius = theme.cardTheme.shape is RoundedRectangleBorder
        ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
        : BorderRadius.circular(kDefaultCardRadius);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and optional count badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title!,
                      style: AppTextStyles.h3.copyWith(fontSize: 17),
                    ),
                    if (badgeCount != null && badgeCount! > 0) ...[
                      const SizedBox(width: 8),
                      StatusBadge(
                        text: '$badgeCount',
                        color: AppColors.textPrimary,
                        backgroundColor: AppColors.primary,
                      ),
                    ],
                  ],
                ),

                // Trailing actions and optional View All button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (headerActions != null) ...headerActions!,
                    if (onViewAll != null)
                      InkWell(
                        onTap: onViewAll,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                viewAllLabel,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                FeatherIcons.chevronRight,
                                size: 13,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            const SizedBox(height: 14),
          ],
          if (expandChild) Expanded(child: child) else child,
        ],
      ),
    );
  }
}
