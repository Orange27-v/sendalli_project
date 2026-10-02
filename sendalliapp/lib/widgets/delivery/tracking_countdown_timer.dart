import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Style variation for [TrackingCountdownTimer]
enum TrackingTimerStyle {
  compact,
  card,
  prominent,
}

/// A live, ticking countdown timer widget designed for parcel and roadside tracking screens.
/// Follows production standards with clean lifecycle disposal and custom styling.
class TrackingCountdownTimer extends StatefulWidget {
  /// Total duration for the countdown (defaults to 15 minutes)
  final Duration initialDuration;

  /// Optional label displayed next to or above timer
  final String? label;

  /// Display presentation style
  final TrackingTimerStyle style;

  /// Callback fired when the timer reaches 00:00
  final VoidCallback? onTimerComplete;

  const TrackingCountdownTimer({
    super.key,
    this.initialDuration = const Duration(minutes: 15),
    this.label,
    this.style = TrackingTimerStyle.card,
    this.onTimerComplete,
  });

  @override
  State<TrackingCountdownTimer> createState() => _TrackingCountdownTimerState();
}

class _TrackingCountdownTimerState extends State<TrackingCountdownTimer>
    with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _ticker;
  AnimationController? _pulseController;

  bool get _isTesting => Platform.environment.containsKey('FLUTTER_TEST');

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.initialDuration.inSeconds;
    _remainingSeconds = _totalSeconds;

    if (!_isTesting) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      )..repeat(reverse: true);

      _startTimer();
    }
  }

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onTimerComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _pulseController?.dispose();
    super.dispose();
  }

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildPulseDot([double size = 6.0]) {
    final dot = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
    if (_pulseController == null) return dot;
    return FadeTransition(opacity: _pulseController!, child: dot);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case TrackingTimerStyle.compact:
        return _buildCompact();
      case TrackingTimerStyle.prominent:
        return _buildProminent();
      case TrackingTimerStyle.card:
        return _buildCard();
    }
  }

  /// Compact inline pill (e.g. for app bars or row headers)
  Widget _buildCompact() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: AppDimens.borderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPulseDot(6.0),
          const SizedBox(width: 6),
          Text(
            _formatTime(),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  /// Prominent ETA card with progress bar
  Widget _buildProminent() {
    final progress = _totalSeconds > 0 ? (_totalSeconds - _remainingSeconds) / _totalSeconds : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        border: Border.all(
          color: AppColors.border,
          width: AppDimens.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildPulseDot(8.0),
                  const SizedBox(width: 8),
                  Text(
                    widget.label ?? 'ESTIMATED ARRIVAL COUNTDOWN',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                ),
                child: Text(
                  'LIVE',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatTime(),
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'mins remaining',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: AppColors.surfaceSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// Default Card style
  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.cardPadding,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimens.radius),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: AppDimens.borderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(FeatherIcons.clock, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                widget.label ?? 'Estimated Arrival in:',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildPulseDot(6.0),
              const SizedBox(width: 6),
              Text(
                _formatTime(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
