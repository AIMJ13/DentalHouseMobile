import 'package:flutter/material.dart';
import '../../Data/citas_data.dart';
import '../../Theme/app_colors.dart';
import '../../Widget/doctor_app_bar.dart';
import '../../Widget/doctor_bottom_nav.dart';
import '../../Widget/stats_summary_row.dart';
import '../../Widget/section_header.dart';
import '../../Widget/cita_registrada_card.dart';
import '../../Widget/status_badge.dart';
import '../../Widget/custom_text_field.dart';

class AgendaCitasScreen extends StatefulWidget {
  const AgendaCitasScreen({super.key});

  @override
  State<AgendaCitasScreen> createState() => _AgendaCitasScreenState();
}

class _AgendaCitasScreenState extends State<AgendaCitasScreen> {
  final TextEditingController _busquedaController = TextEditingController();
  String _busqueda = '';
  String _estadoFiltro = 'Todos';

  @override
  void initState() {
    super.initState();
    _busquedaController.addListener(() {
      setState(() {
        _busqueda = _busquedaController.text;
      });
    });
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

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

  Color _colorDesde(String? tipo) {
    switch (tipo) {
      case 'success':
        return AppColors.success;
      case 'info':
        return AppColors.info;
      case 'warning':
        return AppColors.warning;
      case 'danger':
        return AppColors.danger;
      default:
        return Colors.white;
    }
  }

  Color _textColorDesde(String? tipo) {
    return tipo == null || tipo == 'neutral'
        ? AppColors.textDark
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final citasFiltradas = citasRegistradas.where((c) {
      final coincideEstado =
          _estadoFiltro == 'Todos' || c['estado'] == _estadoFiltro;
      final texto = _busqueda.toLowerCase();
      final coincideBusqueda = c['paciente']!.toLowerCase().contains(texto) ||
          c['motivo']!.toLowerCase().contains(texto);
      return coincideEstado && coincideBusqueda;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DoctorAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_month, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agenda de Citas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Administra las citas registradas entre pacientes y doctores.',
                        style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            StatsSummaryRow(items: resumenCitasItems),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Buscar por paciente o motivo...',
              controller: _busquedaController,
              prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.calendar_today,
                            size: 16, color: AppColors.textGrey),
                        SizedBox(width: 8),
                        Text('dd/mm/aaaa',
                            style: TextStyle(color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _estadoFiltro,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Todos', child: Text('Todos los estados')),
                      DropdownMenuItem(
                          value: 'Programada', child: Text('Programada')),
                      DropdownMenuItem(
                          value: 'Completada', child: Text('Completada')),
                      DropdownMenuItem(
                          value: 'Cancelada', child: Text('Cancelada')),
                      DropdownMenuItem(
                          value: 'No asistió', child: Text('No asistió')),
                    ],
                    onChanged: (valor) {
                      setState(() {
                        _estadoFiltro = valor ?? 'Todos';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Todos los doctores',
                            style: TextStyle(color: AppColors.textGrey)),
                        Icon(Icons.keyboard_arrow_down,
                            color: AppColors.textGrey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Hoy',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _busquedaController.clear();
                      _estadoFiltro = 'Todos';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Text('Limpiar',
                        style: TextStyle(color: AppColors.textGrey)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SectionHeaderRow(
              title: 'Citas Registradas',
              trailingText: '${citasFiltradas.length} mostradas',
            ),
            const SizedBox(height: 8),
            if (citasFiltradas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No se encontraron citas con ese filtro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ),
            ...citasFiltradas.map(
              (c) => CitaRegistradaCard(
                codigo: c['codigo']!,
                estado: c['estado']!,
                estadoTipo: _tipoDesde(c['estadoTipo']),
                paciente: c['paciente']!,
                pacienteId: c['pacienteId']!,
                motivo: c['motivo']!,
                doctor: c['doctor']!,
                fecha: c['fecha']!,
                hora: c['hora']!,
                accionSecundariaTexto: c['accionTexto']!,
                accionSecundariaColor: _colorDesde(c['accionTipo']),
                accionSecundariaTextColor: _textColorDesde(c['accionTipo']),
                onEditar: () {},
                onAccionSecundaria: () {},
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          // Próximo paso: abrir la pantalla de 'Agendar Cita'.
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const DoctorBottomNav(currentIndex: 1),
    );
  }
}