import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';

enum StatusType { success, info, warning, danger, neutral }

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = StatusType.neutral,
  });

  Color get _bgColor {
    switch (type) {
      case StatusType.success:
        return AppColors.successLight;
      case StatusType.info:
        return AppColors.infoLight;
      case StatusType.warning:
        return AppColors.warningLight;
      case StatusType.danger:
        return AppColors.dangerLight;
      case StatusType.neutral:
        return Colors.grey[200]!;
    }
  }

  Color get _textColor {
    switch (type) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.info:
        return AppColors.info;
      case StatusType.warning:
        return AppColors.warning;
      case StatusType.danger:
        return AppColors.danger;
      case StatusType.neutral:
        return Colors.grey[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}