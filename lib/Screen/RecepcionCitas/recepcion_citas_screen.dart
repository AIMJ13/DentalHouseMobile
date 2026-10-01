import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/dental_logo.dart';
import '../../Widget/custom_bottom_nav.dart';
import '../../routes.dart';
import '../Citas/cita_modal.dart';

class Cita {
  final String codigo;
  String paciente;
  String motivo;
  String doctor;
  String fecha;
  String hora;
  String estado;

  Cita({
    required this.codigo,
    required this.paciente,
    required this.motivo,
    required this.doctor,
    String? fecha,
    String? hora,
    String? fechaHora,
    required this.estado,
  })  : fecha = fecha ?? (fechaHora?.split(' • ').first ?? ''),
        hora = hora ?? ((fechaHora?.split(' • ').length ?? 0) > 1 ? fechaHora!.split(' • ')[1] : '');

  String get fechaHora => '$fecha • $hora';
}

class RecepcionCitasScreen extends StatefulWidget {
  const RecepcionCitasScreen({super.key});

  @override
  State<RecepcionCitasScreen> createState() => _RecepcionCitasScreenState();
}

class _RecepcionCitasScreenState extends State<RecepcionCitasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroDoctor = 'Todos';
  String _filtroEstado = 'Todos';

  final List<Map<String, dynamic>> _citas = [
    {
      'codigo': 'CIT-001',
      'paciente': 'Miurell Raquel',
      'pacienteId': '4',
      'motivo': 'Consulta general',
      'doctor': 'Dra. Olinda Pérez',
      'fecha': '06/06/2025',
      'hora': '09:30 AM',
      'estado': 'No asistió',
    },
    {
      'codigo': 'CIT-002',
      'paciente': 'Lester Palacio',
      'pacienteId': '1',
      'motivo': 'Limpieza dental',
      'doctor': 'Dr. Fabio Reyes',
      'fecha': '01/06/2026',
      'hora': '08:00 AM',
      'estado': 'Cancelada',
    },
    {
      'codigo': 'CIT-003',
      'paciente': 'Roman Rosales',
      'pacienteId': '2',
      'motivo': 'Ortodoncia',
      'doctor': 'Dra. María González',
      'fecha': '06/06/2025',
      'hora': '10:00 AM',
      'estado': 'Programada',
    },
  ];

  List<String> get _doctoresDisponibles {
    final nombres = _citas.map((c) => c['doctor'] as String).toSet().toList();
    nombres.sort();
    return ['Todos', ...nombres];
  }

  List<String> get _estadosDisponibles {
    final estados = _citas.map((c) => c['estado'] as String).toSet().toList();
    estados.sort();
    return ['Todos', ...estados];
  }

  List<Map<String, dynamic>> get _citasFiltradas {
    final query = _searchController.text.toLowerCase().trim();
    return _citas.where((c) {
      final paciente = (c['paciente'] as String).toLowerCase();
      final motivo = (c['motivo'] as String).toLowerCase();
      final coincideBusqueda = query.isEmpty || paciente.contains(query) || motivo.contains(query);
      final coincideDoctor = _filtroDoctor == 'Todos' || c['doctor'] == _filtroDoctor;
      final coincideEstado = _filtroEstado == 'Todos' || c['estado'] == _filtroEstado;
      return coincideBusqueda && coincideDoctor && coincideEstado;
    }).toList();
  }

  /// true si hay otra cita activa del mismo doctor en la misma fecha/hora.
  bool _hayChoqueHorario({
    required String codigoActual,
    required String doctor,
    required String fecha,
    required String hora,
  }) {
    for (var c in _citas) {
      if (c['codigo'] == codigoActual) continue;
      if (c['estado'] == 'Cancelada') continue;
      if (c['doctor'] == doctor && c['fecha'] == fecha && c['hora'] == hora) {
        return true;
      }
    }
    return false;
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'Programada':
        return Colors.blue;
      case 'Completada':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      case 'No asistió':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  void _abrirModalCita({Map<String, dynamic>? cita}) {
    showDialog(
      context: context,
      builder: (context) => CitaModal(
        id: cita?['codigo'] as String?,
        codigo: cita?['codigo'] as String?,
        paciente: cita?['paciente'] as String?,
        pacienteId: cita?['pacienteId'] as String?,
        motivo: cita?['motivo'] as String?,
        doctor: cita?['doctor'] as String?,
        fecha: cita?['fecha'] as String?,
        hora: cita?['hora'] as String?,
        estado: cita?['estado'] as String?,
        onGuardar: ({
          required String paciente,
          required String pacienteId,
          required String motivo,
          required String doctor,
          required String fecha,
          required String hora,
          required String estado,
        }) {
          final codigoActual = cita?['codigo'] as String? ?? '';
          if (estado != 'Cancelada' &&
              _hayChoqueHorario(codigoActual: codigoActual, doctor: doctor, fecha: fecha, hora: hora)) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Choque de horario'),
                content: Text('El doctor $doctor ya tiene una cita el $fecha a las $hora. Los cambios no se guardaron.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Entendido'),
                  ),
                ],
              ),
            );
            return;
          }

          setState(() {
            if (cita != null) {
              cita['paciente'] = paciente;
              cita['pacienteId'] = pacienteId;
              cita['motivo'] = motivo;
              cita['doctor'] = doctor;
              cita['fecha'] = fecha;
              cita['hora'] = hora;
              cita['estado'] = estado;
            } else {
              final nuevoCodigo = 'CIT-00${_citas.length + 1}';
              _citas.insert(0, {
                'codigo': nuevoCodigo,
                'paciente': paciente,
                'pacienteId': pacienteId,
                'motivo': motivo,
                'doctor': doctor,
                'fecha': fecha,
                'hora': hora,
                'estado': estado,
              });
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cita != null ? 'Cita actualizada correctamente' : 'Cita agendada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final citasFiltradas = _citasFiltradas;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const DentalLogo(),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pushNamed(context, Routes.perfil),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue[700],
                    child: const Text('R', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Text('Recepcionista', style: TextStyle(fontSize: 12, color: Colors.blue[800], fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54, size: 20),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Agenda de Citas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Administra todas las citas registradas entre pacientes y doctores.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBadge('Total', _citas.length.toString(), Colors.black87),
                _buildBadge(
                  'Programadas',
                  _citas.where((c) => c['estado'] == 'Programada').length.toString(),
                  Colors.blue,
                ),
                _buildBadge(
                  'Completadas',
                  _citas.where((c) => c['estado'] == 'Completada').length.toString(),
                  Colors.green,
                ),
                _buildBadge(
                  'Canceladas',
                  _citas.where((c) => c['estado'] == 'Cancelada').length.toString(),
                  Colors.red,
                ),
                _buildBadge(
                  'No asistió',
                  _citas.where((c) => c['estado'] == 'No asistió').length.toString(),
                  Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por paciente o motivo...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _filtroDoctor,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: [
                      for (var doc in _doctoresDisponibles)
                        DropdownMenuItem(
                          value: doc,
                          child: Text(doc == 'Todos' ? 'Todos los doctores' : doc, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: (value) => setState(() => _filtroDoctor = value ?? 'Todos'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _filtroEstado,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: [
                      for (var est in _estadosDisponibles)
                        DropdownMenuItem(
                          value: est,
                          child: Text(est == 'Todos' ? 'Todos los estados' : est, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: (value) => setState(() => _filtroEstado = value ?? 'Todos'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CITAS REGISTRADAS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                Text('${citasFiltradas.length} mostradas', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: citasFiltradas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text('No se encontraron citas', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: citasFiltradas.length,
                      itemBuilder: (context, index) {
                        final cita = citasFiltradas[index];
                        final estado = cita['estado'] as String;
                        return InkWell(
                          onTap: () => _abrirModalCita(cita: cita),
                          borderRadius: BorderRadius.circular(10),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cita['codigo'] as String,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 12),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _colorEstado(estado).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          estado,
                                          style: TextStyle(color: _colorEstado(estado), fontSize: 11, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text('PACIENTE', style: TextStyle(fontSize: 10, color: Colors.black45)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cita['paciente'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                                    ],
                                  ),
                                  Text(cita['motivo'] as String, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text('DOCTOR: ${cita['doctor']}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  Text('${cita['fecha']} • ${cita['hora']}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalCita(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildBadge(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text('$label: $count', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}