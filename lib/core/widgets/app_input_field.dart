import 'package:flutter/material.dart';
import '../theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ports `SearchField`: a bordered text field with a leading search icon.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTextStyles.body(fontSize: 14),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: AppTextStyles.body(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        prefixIcon: const Icon(
          LucideIcons.search,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Ports `InputField`: a labelled text field with an optional leading icon,
/// used on the Sign In screen.
class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String placeholder;
  final Widget? icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTextStyles.body(fontSize: 14),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTextStyles.body(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            prefixIcon: icon,
          ),
        ),
      ],
    );
  }
}
