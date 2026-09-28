import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/dental_logo.dart';
import '../../routes.dart';
import 'editar_cita_modal.dart';
import 'agendar_cita_modal.dart';

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

  final List<Cita> _citas = [
    Cita(
      codigo: 'CIT-001',
      paciente: 'Miurell Raquel',
      motivo: 'Consulta general',
      doctor: 'Dra. Olinda Pérez',
      fecha: '06/06/2025',
      hora: '09:30 AM',
      estado: 'No asistió',
    ),
    Cita(
      codigo: 'CIT-002',
      paciente: 'Lester Palacio',
      motivo: 'Limpieza dental',
      doctor: 'Dr. Fabio Reyes',
      fecha: '01/06/2026',
      hora: '08:00 AM',
      estado: 'Cancelada',
    ),
    Cita(
      codigo: 'CIT-003',
      paciente: 'Roman Rosales',
      motivo: 'Ortodoncia',
      doctor: 'Dra. María González',
      fecha: '06/06/2025',
      hora: '10:00 AM',
      estado: 'Programada',
    ),
  ];

  List<String> get _doctoresDisponibles {
    final nombres = _citas.map((c) => c.doctor).toSet().toList();
    nombres.sort();
    return ['Todos', ...nombres];
  }

  List<String> get _estadosDisponibles {
    final estados = _citas.map((c) => c.estado).toSet().toList();
    estados.sort();
    return ['Todos', ...estados];
  }

  List<Cita> get _citasFiltradas {
    final query = _searchController.text.toLowerCase().trim();
    return _citas.where((c) {
      final coincideBusqueda = query.isEmpty ||
          c.paciente.toLowerCase().contains(query) ||
          c.motivo.toLowerCase().contains(query);
      final coincideDoctor = _filtroDoctor == 'Todos' || c.doctor == _filtroDoctor;
      final coincideEstado = _filtroEstado == 'Todos' || c.estado == _filtroEstado;
      return coincideBusqueda && coincideDoctor && coincideEstado;
    }).toList();
  }

  /// Devuelve un mensaje de error si ya existe otra cita activa con el mismo
  /// doctor en la misma fecha/hora, o null si no hay choque.
  String? _validarChoqueHorario({
    required Cita citaActual,
    required String nuevaFecha,
    required String nuevaHora,
  }) {
    for (var c in _citas) {
      if (c.codigo == citaActual.codigo) continue;
      if (c.estado == 'Cancelada') continue;
      if (c.doctor == citaActual.doctor && c.fecha == nuevaFecha && c.hora == nuevaHora) {
        return 'El doctor ${citaActual.doctor} ya tiene una cita el $nuevaFecha a las $nuevaHora.';
      }
    }
    return null;
  }

  void _onBottomNavTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, Routes.home);
      return;
    }
    if (index == 1) {
      Navigator.pushReplacementNamed(context, Routes.recepcionPacientes);
      return;
    }
    if (index == 2) {
      Navigator.pushReplacementNamed(context, Routes.recepcionEspecialidades);
      return;
    }
    if (index == 3) {
      Navigator.pushReplacementNamed(context, Routes.recepcionDoctores);
      return;
    }
    if (index == 4) {
      Navigator.pushReplacementNamed(context, Routes.recepcionServicios);
      return;
    }
  }

  List<BottomNavigationBarItem> _obtenerItemsNavegacion() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
      BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
      BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Especialidad'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Doctor'),
      BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _abrirEditarCita(Cita cita, {bool esReagendar = false}) {
    showDialog(
      context: context,
      builder: (context) => EditarCitaDialog(
        cita: cita,
        esReagendar: esReagendar,
        validarChoque: (fecha, hora) => _validarChoqueHorario(
          citaActual: cita,
          nuevaFecha: fecha,
          nuevaHora: hora,
        ),
        onGuardar: (motivo, fecha, hora) {
          setState(() {
            cita.motivo = motivo;
            cita.fecha = fecha;
            cita.hora = hora;
            if (esReagendar) {
              cita.estado = 'Programada';
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(esReagendar ? 'Cita reagendada correctamente' : 'Cita actualizada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _cancelarCita(Cita cita) {
    setState(() {
      cita.estado = 'Cancelada';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cita cancelada'), backgroundColor: Colors.red),
    );
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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        titleSpacing: Navigator.canPop(context) ? 0 : 16,
        title: const DentalLogo(),
        actions: [
          Container(
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
                  _citas.where((c) => c.estado == 'Programada').length.toString(),
                  Colors.blue,
                ),
                _buildBadge(
                  'Completadas',
                  _citas.where((c) => c.estado == 'Completada').length.toString(),
                  Colors.green,
                ),
                _buildBadge(
                  'Canceladas',
                  _citas.where((c) => c.estado == 'Cancelada').length.toString(),
                  Colors.red,
                ),
                _buildBadge(
                  'No asistió',
                  _citas.where((c) => c.estado == 'No asistió').length.toString(),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: [
                      for (var doc in _doctoresDisponibles)
                        DropdownMenuItem(
                          value: doc,
                          child: Text(
                            doc == 'Todos' ? 'Todos los doctores' : doc,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filtroDoctor = value ?? 'Todos';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _filtroEstado,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: [
                      for (var est in _estadosDisponibles)
                        DropdownMenuItem(
                          value: est,
                          child: Text(
                            est == 'Todos' ? 'Todos los estados' : est,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filtroEstado = value ?? 'Todos';
                      });
                    },
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
                Text(
                  '${citasFiltradas.length} mostradas',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
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
                          Text(
                            'No se encontraron citas',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: citasFiltradas.length,
                      itemBuilder: (context, index) {
                        final cita = citasFiltradas[index];
                        return Card(
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
                                      cita.codigo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _colorEstado(cita.estado).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        cita.estado,
                                        style: TextStyle(
                                          color: _colorEstado(cita.estado),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'PACIENTE',
                                  style: TextStyle(fontSize: 10, color: Colors.black45),
                                ),
                                Text(
                                  cita.paciente,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Text(
                                  cita.motivo,
                                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'DOCTOR: ${cita.doctor}',
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                Text(
                                  cita.fechaHora,
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => _abrirEditarCita(cita),
                                        child: const Text('Editar'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: cita.estado == 'Cancelada' ? Colors.blue : Colors.red,
                                        ),
                                        onPressed: () {
                                          if (cita.estado == 'Cancelada') {
                                            _abrirEditarCita(cita, esReagendar: true);
                                          } else {
                                            _cancelarCita(cita);
                                          }
                                        },
                                        child: Text(
                                          cita.estado == 'Cancelada' ? 'Reagendar' : 'Cancelar',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AgendarCitaModal(),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) => _onBottomNavTapped(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: _obtenerItemsNavegacion(),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}