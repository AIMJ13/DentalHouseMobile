import 'package:flutter/material.dart';
import '../../Data/pacientes_data.dart';
import '../../Theme/app_colors.dart';
import '../../Widget/doctor_app_bar.dart';
import '../../Widget/doctor_bottom_nav.dart';
import '../../Widget/stats_summary_row.dart';
import '../../Widget/section_header.dart';
import '../../Widget/paciente_card.dart';
import '../../Widget/paciente_form_dialog.dart';
import '../../Widget/confirmar_dialog.dart';
import '../../Widget/status_badge.dart';
import '../../Widget/custom_text_field.dart';

class GestionPacientesScreen extends StatefulWidget {
  const GestionPacientesScreen({super.key});

  @override
  State<GestionPacientesScreen> createState() =>
      _GestionPacientesScreenState();
}

class _GestionPacientesScreenState extends State<GestionPacientesScreen> {
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
      case 'danger':
        return StatusType.danger;
      default:
        return StatusType.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtramos la lista según el estado elegido y el texto buscado.
    final pacientesFiltrados = pacientesRegistrados.where((p) {
      final coincideEstado =
          _estadoFiltro == 'Todos' || p['estado'] == _estadoFiltro;
      final coincideBusqueda =
          p['nombre']!.toLowerCase().contains(_busqueda.toLowerCase());
      return coincideEstado && coincideBusqueda;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DoctorAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Gestión de Pacientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Administra la información clínica y de contacto de los pacientes.',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(height: 14),
            StatsSummaryRow(items: resumenPacientesItems),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Buscar paciente por nombre...',
              controller: _busquedaController,
              prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _estadoFiltro,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Todos', child: Text('Todos los estados')),
                DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
              ],
              onChanged: (valor) {
                setState(() {
                  _estadoFiltro = valor ?? 'Todos';
                });
              },
            ),
            const SizedBox(height: 20),
            SectionHeaderRow(
              title: 'Directorio de Pacientes',
              trailingText: '${pacientesFiltrados.length} mostrados',
            ),
            const SizedBox(height: 8),
            if (pacientesFiltrados.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No se encontraron pacientes con ese filtro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ),
            ...pacientesFiltrados.map(
              (p) => PacienteCard(
                codigo: p['codigo']!,
                nombre: p['nombre']!,
                telefono: p['telefono']!,
                nacimiento: p['nacimiento']!,
                estado: p['estado']!,
                estadoTipo: _tipoDesde(p['estadoTipo']),
                onEditar: () {
                  showPacienteFormDialog(
                    context,
                    esEdicion: true,
                    nombreInicial: p['nombre']!.split(' ').first,
                    telefonoInicial: p['telefono'],
                    nacimientoInicial: p['nacimiento'],
                    estadoInicial: p['estado'],
                  );
                },
                onCambiarEstado: () {
                  final bool esActivo = p['estado']!.toLowerCase() == 'activo';
                  showConfirmarDialog(
                    context,
                    titulo: esActivo
                        ? '¿Desactivar Paciente?'
                        : '¿Activar Paciente?',
                    mensaje:
                        '¿Estás seguro de que deseas ${esActivo ? 'desactivar' : 'activar'} '
                        'al paciente "${p['nombre']}" (${p['codigo']})?',
                    textoConfirmar: esActivo ? 'Sí, Desactivar' : 'Sí, Activar',
                    colorConfirmar:
                        esActivo ? AppColors.danger : AppColors.success,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showPacienteFormDialog(context, esEdicion: false);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const DoctorBottomNav(currentIndex: 2),
    );
  }
}