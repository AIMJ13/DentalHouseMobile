import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';
import 'status_badge.dart';
import 'custom_button.dart';

class PacienteCard extends StatelessWidget {
  final String codigo;
  final String nombre;
  final String telefono;
  final String nacimiento;
  final String estado;
  final StatusType estadoTipo;
  final VoidCallback? onEditar;
  final VoidCallback? onCambiarEstado;

  const PacienteCard({
    super.key,
    required this.codigo,
    required this.nombre,
    required this.telefono,
    required this.nacimiento,
    required this.estado,
    required this.estadoTipo,
    this.onEditar,
    this.onCambiarEstado,
  });

  @override
  Widget build(BuildContext context) {
    final bool esActivo = estado.toLowerCase() == 'activo';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                codigo,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGrey,
                ),
              ),
              StatusBadge(text: estado, type: estadoTipo),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      telefono,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      nacimiento,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomButton(text: 'Editar', onPressed: onEditar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: esActivo ? 'Desactivar' : 'Activar',
                  onPressed: onCambiarEstado,
                  color: esActivo ? AppColors.danger : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}