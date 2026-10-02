import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/navigation/app_navigator.dart';

/// Production-ready Custom AppBar enforcing Sendalli brand standards:
/// 1. Vibrant Green background (#009944 / AppColors.primary).
/// 2. Crisp White header font color (#FFFFFF / AppColors.textInverse).
/// 3. White leading navigation button with safe fallback routing.
/// 4. White status bar icons across both iOS Dynamic Island & Android.
/// 5. Zero elevation and no scroll-under discoloration.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Primary header title string. If [titleWidget] is provided, this is ignored.
  final String? title;

  /// Optional custom title widget for complex multi-line or styled headers.
  final Widget? titleWidget;

  /// Optional secondary subtitle string rendered under the title in soft white.
  final String? subtitle;

  /// Whether to show the leading back button. Defaults to true.
  final bool showLeading;

  /// Explicit custom leading widget. Overrides default back arrow button.
  final Widget? leading;

  /// Optional callback invoked when default leading back button is tapped.
  /// If null, defaults to [AppNavigator.safePop].
  final VoidCallback? onLeadingPressed;

  /// Optional trailing action widgets (e.g. RandomizeButton, logout, close).
  final List<Widget>? actions;

  /// Whether title is centered. Defaults to true as shown in design reference.
  final bool centerTitle;

  /// Header background color. Defaults to [AppColors.primary] (#009944).
  final Color backgroundColor;

  /// Header font and icon color. Defaults to [AppColors.textInverse] (white).
  final Color foregroundColor;

  /// Elevation of the app bar. Defaults to 0.
  final double elevation;

  /// Optional bottom widget (e.g. TabBar or progress indicator).
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.showLeading = true,
    this.leading,
    this.onLeadingPressed,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.textInverse,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (showLeading) {
      leadingWidget = IconButton(
        icon: Icon(FeatherIcons.arrowLeft, size: 20, color: foregroundColor),
        tooltip: 'Back',
        onPressed: () {
          if (onLeadingPressed != null) {
            onLeadingPressed!();
          } else {
            AppNavigator.safePop(context);
          }
        },
      );
    }

    Widget? effectiveTitle;
    if (titleWidget != null) {
      effectiveTitle = titleWidget;
    } else if (title != null) {
      if (subtitle != null && subtitle!.isNotEmpty) {
        effectiveTitle = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: GoogleFonts.plusJakartaSans(
                color: foregroundColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: GoogleFonts.plusJakartaSans(
                color: foregroundColor.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      } else {
        effectiveTitle = Text(
          title!,
          style: GoogleFonts.plusJakartaSans(
            color: foregroundColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        );
      }
    }

    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      title: effectiveTitle,
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(color: foregroundColor),
      actionsIconTheme: IconThemeData(color: foregroundColor),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android: white status bar icons on green
        statusBarBrightness: Brightness.dark,      // iOS: white status bar icons on green
      ),
    );
  }
}
