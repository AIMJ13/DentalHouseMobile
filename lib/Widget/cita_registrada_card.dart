import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';
import 'status_badge.dart';
import 'custom_button.dart';

class CitaRegistradaCard extends StatelessWidget {
  final String codigo;
  final String estado;
  final StatusType estadoTipo;
  final String paciente;
  final String pacienteId;
  final String motivo;
  final String doctor;
  final String fecha;
  final String hora;
  final String accionSecundariaTexto;
  final Color accionSecundariaColor;
  final Color accionSecundariaTextColor;
  final VoidCallback? onEditar;
  final VoidCallback? onAccionSecundaria;
  final String? accionTerciariaTexto;
  final VoidCallback? onAccionTerciaria;

  const CitaRegistradaCard({
    super.key,
    required this.codigo,
    required this.estado,
    required this.estadoTipo,
    required this.paciente,
    required this.pacienteId,
    required this.motivo,
    required this.doctor,
    required this.fecha,
    required this.hora,
    required this.accionSecundariaTexto,
    required this.accionSecundariaColor,
    required this.accionSecundariaTextColor,
    this.onEditar,
    this.onAccionSecundaria,
    this.accionTerciariaTexto,
    this.onAccionTerciaria,
  });

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  codigo,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              StatusBadge(text: estado, type: estadoTipo),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'PACIENTE:',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textGrey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                paciente,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                '(ID: $pacienteId)',
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              motivo,
              style: const TextStyle(fontSize: 11, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'DOCTOR: $doctor',
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 12, color: AppColors.textGrey),
              const SizedBox(width: 4),
              Text(
                fecha,
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
              const SizedBox(width: 4),
              const Text('•', style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(width: 4),
              Text(
                hora,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
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
                child: Container(
                  decoration: accionSecundariaColor == Colors.white
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        )
                      : null,
                  child: CustomButton(
                    text: accionSecundariaTexto,
                    onPressed: onAccionSecundaria,
                    color: accionSecundariaColor,
                    textColor: accionSecundariaTextColor,
                  ),
                ),
              ),
              // Acción rápida extra (por ahora solo "Completar"),
              // solo aparece cuando la pantalla la habilita.
              if (accionTerciariaTexto != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: accionTerciariaTexto!,
                    onPressed: onAccionTerciaria,
                    color: AppColors.success,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}