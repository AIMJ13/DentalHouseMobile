import 'package:flutter/material.dart';
import '../../Data/pacientes_data.dart';
import '../../Theme/app_colors.dart';
import '../../Widget/doctor_app_bar.dart';
import '../../Widget/doctor_bottom_nav.dart';
import '../../Widget/stats_summary_row.dart';
import '../../Widget/section_header.dart';
import '../../Widget/paciente_card.dart';
import '../../Widget/paciente_form_dialog.dart';
import '../../Widget/status_badge.dart';
import '../../Widget/custom_text_field.dart';

class GestionPacientesScreen extends StatefulWidget {
  const GestionPacientesScreen({super.key});

  @override
  State<GestionPacientesScreen> createState() =>
      _GestionPacientesScreenState();
}

class _GestionPacientesScreenState extends State<GestionPacientesScreen> {
  late List<Map<String, String>> _pacientes;

  final TextEditingController _busquedaController = TextEditingController();
  String _busqueda = '';
  String _estadoFiltro = 'Todos';

  @override
  void initState() {
    super.initState();
    _pacientes =
        pacientesRegistrados.map((p) => Map<String, String>.from(p)).toList();
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

  StatusType _tipoDesdeEstado(String estado) {
    return estado.toLowerCase() == 'activo'
        ? StatusType.success
        : StatusType.danger;
  }

  void _abrirNuevoPaciente() {
    showPacienteFormDialog(
      context,
      esEdicion: false,
      onGuardar: (datos) {
        setState(() {
          final numero = _pacientes.length + 1;
          _pacientes.add({
            'codigo': 'PAC-${numero.toString().padLeft(3, '0')}',
            'nombre': '${datos['nombre']} ${datos['apellido']}'.trim(),
            'telefono': datos['telefono']!,
            'nacimiento': datos['nacimiento']!,
            'estado': datos['estado']!,
            'estadoTipo': datos['estado'] == 'Activo' ? 'success' : 'danger',
          });
        });
      },
    );
  }

  void _abrirEditarPaciente(String codigo) {
    final index = _pacientes.indexWhere((p) => p['codigo'] == codigo);
    if (index == -1) return;
    final actual = _pacientes[index];
    final partesNombre = actual['nombre']!.split(' ');

    showPacienteFormDialog(
      context,
      esEdicion: true,
      nombreInicial: partesNombre.first,
      apellidoInicial:
          partesNombre.length > 1 ? partesNombre.sublist(1).join(' ') : '',
      telefonoInicial: actual['telefono'],
      nacimientoInicial: actual['nacimiento'],
      estadoInicial: actual['estado'],
      onGuardar: (datos) {
        setState(() {
          _pacientes[index] = {
            ...actual,
            'nombre': '${datos['nombre']} ${datos['apellido']}'.trim(),
            'telefono': datos['telefono']!,
            'nacimiento': datos['nacimiento']!,
            'estado': datos['estado']!,
            'estadoTipo': datos['estado'] == 'Activo' ? 'success' : 'danger',
          };
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pacientesFiltrados = _pacientes.where((p) {
      final coincideEstado =
          _estadoFiltro == 'Todos' || p['estado'] == _estadoFiltro;
      final coincideBusqueda =
          p['nombre']!.toLowerCase().contains(_busqueda.toLowerCase());
      return coincideEstado && coincideBusqueda;
    }).toList();

    final resumen = [
      {'etiqueta': 'Total', 'valor': _pacientes.length.toString(), 'tipo': 'neutral'},
      {
        'etiqueta': 'Activos',
        'valor': _pacientes.where((p) => p['estado'] == 'Activo').length.toString(),
        'tipo': 'success',
      },
      {
        'etiqueta': 'Inactivos',
        'valor': _pacientes.where((p) => p['estado'] == 'Inactivo').length.toString(),
        'tipo': 'danger',
      },
    ];

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
            StatsSummaryRow(items: resumen),
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
                estadoTipo: _tipoDesdeEstado(p['estado']!),
                onTap: () => _abrirEditarPaciente(p['codigo']!),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _abrirNuevoPaciente,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const DoctorBottomNav(currentIndex: 2),
    );
  }
}