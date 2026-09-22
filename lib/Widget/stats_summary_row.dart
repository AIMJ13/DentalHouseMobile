import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';

class StatsSummaryRow extends StatelessWidget {
  final List<Map<String, String>> items;

  const StatsSummaryRow({super.key, required this.items});

  Color _colorFor(String? tipo) {
    switch (tipo) {
      case 'info':
        return AppColors.info;
      case 'success':
        return AppColors.success;
      case 'danger':
        return AppColors.danger;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        final color = _colorFor(item['tipo']);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              '${item['etiqueta']}: ',
              style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            Text(
              item['valor'] ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}