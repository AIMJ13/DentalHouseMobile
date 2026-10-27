import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/doctor_home_data.dart';
import '../../../core/constant/app_colors.dart';
import '../../widgets/rendimiento_card.dart';
import '../../widgets/paciente_reciente_tile.dart';
import '../../widgets/cita_hoy_tile.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/section_header.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/doctor_app_bar.dart';
import '../../widgets/stats_summary_row.dart';

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
    final auth = context.watch<AuthProvider>();
    final nombreDoctor = auth.userName.isNotEmpty ? auth.userName : 'Dr. Morales';

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
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                children: [
                  const TextSpan(text: 'Bienvenido de nuevo, '),
                  TextSpan(
                    text: nombreDoctor,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const TextSpan(
                    text: '. Aquí puedes visualizar tus citas e indicaciones clave.',
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
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
