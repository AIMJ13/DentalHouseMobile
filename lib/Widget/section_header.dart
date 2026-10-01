import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';

class SectionHeaderRow extends StatelessWidget {
  final String title;
  final String? trailingText;
  final Color? trailingColor;

  const SectionHeaderRow({
    super.key,
    required this.title,
    this.trailingText,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppColors.textDark,
          ),
        ),
        if (trailingText != null)
          Text(
            trailingText!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: trailingColor ?? AppColors.textGrey,
            ),
          ),
      ],
    );
  }
}