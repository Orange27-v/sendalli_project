import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Reusable customer contact row for rider delivery screens.
///
/// Displays customer avatar, name, and dedicated circular action buttons
/// for direct messaging and phone calls.
class DeliveryCustomerRow extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final VoidCallback? onChatPressed;
  final VoidCallback? onCallPressed;
  final EdgeInsetsGeometry margin;

  const DeliveryCustomerRow({
    super.key,
    required this.name,
    this.avatarUrl,
    this.onChatPressed,
    this.onCallPressed,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryLight,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onChatPressed != null) ...[
            _CircularIconButton(
              icon: FeatherIcons.messageCircle,
              onPressed: onChatPressed,
              tooltip: 'Send message',
            ),
            const SizedBox(width: 8),
          ],
          if (onCallPressed != null) ...[
            _CircularIconButton(
              icon: FeatherIcons.phone,
              onPressed: onCallPressed,
              tooltip: 'Call customer',
            ),
          ],
        ],
      ),
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const _CircularIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E293B), // Dark slate circular button
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: tooltip ?? '',
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
