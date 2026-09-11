import 'package:flutter/material.dart';
import '../theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ports `TopNav`: a back arrow, centred title, and optional trailing
/// action, on a white background with a bottom border.
class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({
    super.key,
    required this.title,
    this.onBack,
    this.action,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: onBack == null
                ? null
                : IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onBack,
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: AppColors.textPrimary,
                    ),
                  ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.display(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(width: 34, child: action),
        ],
      ),
    );
  }
}
