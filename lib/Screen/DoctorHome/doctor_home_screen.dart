import 'package:flutter/material.dart';
import '../../Data/doctor_home_data.dart';
import '../../Theme/app_colors.dart';
import '../../Widget/rendimiento_card.dart';
import '../../Widget/paciente_reciente_tile.dart';
import '../../Widget/cita_hoy_tile.dart';
import '../../Widget/status_badge.dart';
import '../../Widget/section_header.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/doctor_bottom_nav.dart';
import '../../Widget/doctor_app_bar.dart';
import '../../Widget/stats_summary_row.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  StatusType _tipoDesde(String? valor) {
    switch (valor) {
      case 'success':
        return StatusType.success;
      case 'info':
        return StatusType.info;
      case 'warning':
        return StatusType.warning;
      case 'danger':
        return StatusType.danger;
      default:
        return StatusType.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
              appBar: const DoctorAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Panel Principal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                StatusBadge(text: 'Hoy', type: StatusType.neutral),
              ],
            ),
            const SizedBox(height: 4),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                children: [
                  TextSpan(text: 'Bienvenido de nuevo, '),
                  TextSpan(
                    text: 'Dr. Morales',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  TextSpan(
                    text:
                        '. Aquí puedes visualizar tus citas e indicaciones clave.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            StatsSummaryRow(items: resumenDiarioDoctor),
              const SizedBox(height: 16),
            RendimientoCard(
              stats: rendimientoDoctor,
              badgeText: 'En Consulta',
              badgeType: StatusType.success,
            ),
            const SizedBox(height: 20),
            SectionHeaderRow(
              title: 'Pacientes Recientes',
              trailingText: 'Ver todos',
              trailingColor: AppColors.primary,
            ),
            ...pacientesRecientesDoctor.map(
              (p) => PacienteRecienteTile(
                nombre: p['nombre']!,
                detalle: p['detalle']!,
                tiempo: p['tiempo']!,
                estado: p['estado']!,
                estadoTipo: _tipoDesde(p['estadoTipo']),
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeaderRow(
              title: 'Mis Citas de Hoy',
              trailingText: 'Actividad reciente',
            ),
            const SizedBox(height: 8),
            ...citasHoyDoctor.map(
              (c) => CitaHoyTile(
                nombre: c['nombre']!,
                detalle: c['detalle']!,
                hora: c['hora']!,
                subDetalle: c['subDetalle'],
                estado: c['estado']!,
                estadoTipo: _tipoDesde(c['estadoTipo']),
              ),
            ),
           
          ],
        ),
      ),
       bottomNavigationBar: const DoctorBottomNav(currentIndex: 0),
      
    );
  }
}