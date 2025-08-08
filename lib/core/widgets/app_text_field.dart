import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive_utils.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final bool isRequired;
  final String? errorText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.isRequired = false,
    this.errorText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fieldBorderRadius = widget.borderRadius ?? AppDimensions.radiusMedium;
    final fieldContentPadding =
        widget.contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        );

    final defaultBorderColor = isDark
        ? AppColors.darkBorder
        : AppColors.borderLight;
    final defaultFocusedBorderColor =
        widget.focusedBorderColor ?? AppColors.primary;
    final defaultErrorBorderColor =
        widget.errorBorderColor ?? AppColors.warningRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: AppDimensions.fontMedium,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkText : AppColors.textPrimary,
                ),
              ),
              if (widget.isRequired) ...[
                const SizedBox(width: AppDimensions.spacing4),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: AppDimensions.fontMedium,
                    color: AppColors.warningRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: AppDimensions.spacing8),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          validator:
              widget.validator ??
              (widget.isRequired ? _defaultValidator : null),
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: TextStyle(
            fontSize: AppDimensions.fontLarge,
            color: isDark ? AppColors.darkText : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: AppDimensions.fontLarge,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textTertiary,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textTertiary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            contentPadding: fieldContentPadding,
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldBorderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? defaultBorderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldBorderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? defaultBorderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldBorderRadius),
              borderSide: BorderSide(
                color: defaultFocusedBorderColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldBorderRadius),
              borderSide: BorderSide(color: defaultErrorBorderColor, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldBorderRadius),
              borderSide: BorderSide(color: defaultErrorBorderColor, width: 2),
            ),
            errorText: _errorText ?? widget.errorText,
            errorStyle: TextStyle(
              fontSize: AppDimensions.fontSmall,
              color: defaultErrorBorderColor,
            ),
          ),
        ),
      ],
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      setState(() {
        _errorText = 'This field is required';
      });
      return 'This field is required';
    }
    setState(() {
      _errorText = null;
    });
    return null;
  }
}
