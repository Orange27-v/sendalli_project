import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

/// Sendalli Clean UI Design Kit — Adapted from the Nelo design philosophy.
///
/// Features:
/// - Grouped white cards on a quiet light grey scaffold (`elevation: 0`).
/// - Tinted icon tiles (`accent.withValues(alpha: 0.12)`).
/// - Hairline dividers inset to align with the text column.
/// - Minimalist, modern, and readable components for high road-condition legibility.

const double kDefaultCardRadius = 12.0;
const double _maxValueWidth = 140.0;

/// Tinted circular or squircle icon container.
class IconTile extends StatelessWidget {
  final IconData icon;
  final Color tone;
  final double size;
  final double iconSize;
  final bool isCircle;

  const IconTile({
    super.key,
    required this.icon,
    required this.tone,
    this.size = 38.0,
    this.iconSize = 20.0,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(8),
      ),
      child: Icon(icon, size: iconSize, color: tone),
    );
  }
}

/// A clean status badge / pill chip.
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? backgroundColor;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Prevent dark-on-dark unreadable text: if background is dark, automatically use textInverse (white)
    final isDarkBg = backgroundColor == AppColors.primary ||
        backgroundColor == AppColors.primaryDark ||
        backgroundColor == AppColors.primaryAccent;
    final effectiveTextColor = isDarkBg ? AppColors.textInverse : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: effectiveTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Profile identity block at the top of a user or role screen.
class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String roleBadgeText;
  final Color accent;
  final String? initial;
  final bool isVerified;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.roleBadgeText,
    required this.accent,
    this.initial,
    this.isVerified = true,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final avatarLetter = (initial != null && initial!.isNotEmpty)
        ? initial!
        : (name.isNotEmpty ? name[0] : 'S');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(kDefaultCardRadius),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with soft accent ring
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accent.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: accent.withValues(alpha: 0.2),
                      child: Text(
                        avatarLetter.toUpperCase(),
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  if (isVerified)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FeatherIcons.check,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Name & Contact details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.h3.copyWith(fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Role chip
              StatusBadge(
                text: roleBadgeText,
                color: AppColors.textPrimary,
                backgroundColor: accent.withValues(alpha: 0.2),
              ),
            ],
          ),

          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            const SizedBox(height: 12),
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      actionLabel!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      FeatherIcons.chevronRight,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A labelled group of settings or information rows inside a single card.
class SettingsGroup extends StatelessWidget {
  final String? label;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const SettingsGroup({
    super.key,
    this.label,
    required this.children,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              label!.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
        Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(kDefaultCardRadius),
            border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 66),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A tappable row with tinted icon tile, title, optional value, and chevron.
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final Color accent;
  final VoidCallback? onTap;
  final bool isDestructive;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.accent,
    this.value,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final tone = isDestructive ? AppColors.danger : accent;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            IconTile(icon: icon, tone: tone),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? AppColors.danger : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null && value!.isNotEmpty) ...[
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxValueWidth),
                child: Text(
                  value!,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (!isDestructive) ...[
              const SizedBox(width: 6),
              const Icon(
                FeatherIcons.chevronRight,
                size: 18,
                color: AppColors.textMuted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A clean switch row for toggleable settings (e.g. notifications, online status).
class SettingsSwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Color accent;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.accent,
    required this.value,
    required this.onChanged,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconTile(icon: icon, tone: accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            activeThumbColor: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
