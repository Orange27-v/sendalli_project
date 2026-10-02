import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Multi-step horizontal progress tracker matching Screen 3 of the design.
///
/// Features 4 delivery milestones:
/// 1. Order Placed
/// 2. In Kitchen / Hub Sorted
/// 3. On Route with Keke
/// 4. Delivered
class OrderStepProgress extends StatelessWidget {
  /// Current active step (0 = Placed, 1 = Processing, 2 = On Route, 3 = Delivered).
  final int currentStep;

  /// Optional custom message displayed under the progress bar.
  final String? statusMessage;

  const OrderStepProgress({
    super.key,
    required this.currentStep,
    this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    const steps = [
      _StepItem(icon: FeatherIcons.check, label: 'Placed'),
      _StepItem(icon: FeatherIcons.box, label: 'Kitchen/Hub'),
      _StepItem(icon: FeatherIcons.truck, label: 'On Route'),
      _StepItem(icon: FeatherIcons.home, label: 'Delivered'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Stepper Bar
        Row(
          children: [
            for (int i = 0; i < steps.length; i++) ...[
              // Step Node
              _StepCircle(
                icon: steps[i].icon,
                isActive: i <= currentStep,
                isCompleted: i < currentStep,
              ),

              // Connecting Line
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 3,
                    color: i < currentStep
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
            ],
          ],
        ),

        if (statusMessage != null && statusMessage!.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            statusMessage!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepItem {
  final IconData icon;
  final String label;

  const _StepItem({required this.icon, required this.label});
}

class _StepCircle extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isCompleted;

  const _StepCircle({
    required this.icon,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive ? AppColors.primary : AppColors.surface;
    final iconColor = isActive ? AppColors.textInverse : AppColors.textMuted;
    final borderColor = isActive ? AppColors.primary : AppColors.border;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 15,
          color: iconColor,
        ),
      ),
    );
  }
}
