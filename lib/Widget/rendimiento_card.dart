import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';
import 'status_badge.dart';

class RendimientoCard extends StatelessWidget {
  final List<Map<String, String>> stats;
  final String? badgeText;
  final StatusType badgeType;

  const RendimientoCard({
    super.key,
    required this.stats,
    this.badgeText,
    this.badgeType = StatusType.success,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rendimiento',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Indicadores clave del día',
                    style: TextStyle(fontSize: 11, color: AppColors.textGrey),
                  ),
                ],
              ),
              if (badgeText != null)
                StatusBadge(text: badgeText!, type: badgeType),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
            children: stats.map((stat) => _StatTile(stat: stat)).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final Map<String, String> stat;
  const _StatTile({required this.stat});

  Color _subColor(String? tipo) {
    switch (tipo) {
      case 'warning':
        return AppColors.warning;
      case 'success':
        return AppColors.success;
      case 'info':
        return AppColors.info;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat['etiqueta'] ?? '',
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                stat['valor'] ?? '',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              if (stat['sufijo'] != null) ...[
                const SizedBox(width: 4),
                Text(
                  stat['sufijo']!,
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ],
          ),
          if (stat['sub'] != null)
            Text(
              stat['sub']!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _subColor(stat['subTipo']),
              ),
            ),
        ],
      ),
    );
  }
}