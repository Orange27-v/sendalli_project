import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

/// Clean, quiet CustomTextField adhering to the Nelo design flow:
/// - Floating external label with tight, legible typography
/// - Hairline quiet borders (#EEEEEE) with 12px rounded geometry
/// - Zero elevation, high-contrast focus and error states
/// - Specialized constructors for phone, search, and general text
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final Color? borderColor;
  final double borderWidth;
  final bool isPhone;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
    this.borderColor,
    this.borderWidth = 1.0,
    this.isPhone = false,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.inputFormatters,
  });

  /// Specialized search variant with integrated Feather search icon
  const CustomTextField.search({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.prefixIcon = FeatherIcons.search,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
  })  : labelText = null,
        prefixWidget = null,
        obscureText = false,
        keyboardType = TextInputType.text,
        readOnly = false,
        onTap = null,
        maxLines = 1,
        borderColor = null,
        borderWidth = 1.0,
        isPhone = false,
        textCapitalization = TextCapitalization.none,
        validator = null,
        inputFormatters = null;

  /// Specialized phone variant with Nigerian (+234) country prefix container
  const CustomTextField.phone({
    super.key,
    this.controller,
    this.labelText = 'Phone Number',
    this.hintText = '803 123 4567',
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.enabled = true,
  })  : obscureText = false,
        keyboardType = TextInputType.phone,
        readOnly = false,
        onTap = null,
        maxLines = 1,
        borderColor = null,
        borderWidth = 1.0,
        isPhone = true,
        textCapitalization = TextCapitalization.none,
        inputFormatters = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              labelText!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          maxLines: maxLines,
          validator: validator,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: prefixWidget ??
                (isPhone
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        width: 88,
                        child: Text(
                          '🇳🇬 +234',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      )
                    : (prefixIcon != null
                        ? Icon(
                            prefixIcon,
                            size: 18,
                            color: AppColors.textSecondary,
                          )
                        : null)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.surfaceSubtle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.border,
                width: borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.border,
                width: borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryDark,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.danger,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.danger,
                width: 1.5,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

/// Clean dropdown selector matching CustomTextField geometry and aesthetics
class CustomDropdownField<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final IconData? prefixIcon;
  final FormFieldValidator<T>? validator;

  const CustomDropdownField({
    super.key,
    this.labelText,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              labelText!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          icon: const Icon(FeatherIcons.chevronDown, size: 18, color: AppColors.textSecondary),
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: AppColors.textSecondary)
                : null,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
