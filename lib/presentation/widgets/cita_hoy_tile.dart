import 'package:flutter/material.dart';
import 'status_badge.dart';
import '../Theme/app_colors.dart';

class CitaHoyTile extends StatelessWidget {
  final String nombre;
  final String detalle;
  final String hora;
  final String? subDetalle;
  final String estado;
  final StatusType estadoTipo;

  const CitaHoyTile({
    super.key,
    required this.nombre,
    required this.detalle,
    required this.hora,
    this.subDetalle,
    required this.estado,
    required this.estadoTipo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    StatusBadge(text: estado, type: estadoTipo),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  detalle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hora,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (subDetalle != null)
                Text(
                  subDetalle!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}