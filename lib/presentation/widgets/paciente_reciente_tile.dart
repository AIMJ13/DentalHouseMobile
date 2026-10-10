import 'package:flutter/material.dart';
import 'status_badge.dart';
import '../Theme/app_colors.dart';

class PacienteRecienteTile extends StatelessWidget {
  final String nombre;
  final String detalle;
  final String tiempo;
  final String estado;
  final StatusType estadoTipo;

  const PacienteRecienteTile({
    super.key,
    required this.nombre,
    required this.detalle,
    required this.tiempo,
    required this.estado,
    required this.estadoTipo,
  });

  String get _iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              _iniciales,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$detalle · $tiempo',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(text: estado, type: estadoTipo),
        ],
      ),
    );
  }
}