import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/custom_bottom_nav.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/user_badge.dart';
import 'cita_modal.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _filtroEstado = 'Todos los estados';
  String _filtroDoctor = 'Todos los doctores';
  String? _filtroFecha;

  final List<String> _estados = [
    'Todos los estados',
    'Programada',
    'Completada',
    'Cancelada',
    'No asistió',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _obtenerCitasFiltradas() {
    final query = _searchController.text.toLowerCase().trim();

    return listaCitas.where((cita) {
      final paciente = (cita['paciente'] as String? ?? '').toLowerCase();
      final doctor = (cita['doctor'] as String? ?? '').toLowerCase();
      final motivo = (cita['motivo'] as String? ?? '').toLowerCase();
      final codigo = (cita['codigo'] as String? ?? '').toLowerCase();
      final id = (cita['pacienteId'] as String? ?? '').toLowerCase();

      final coincide = query.isEmpty ||
          paciente.contains(query) ||
          doctor.contains(query) ||
          motivo.contains(query) ||
          codigo.contains(query) ||
          id.contains(query);
      if (!coincide) return false;

      if (_filtroEstado != 'Todos los estados') {
        if ((cita['estado'] as String? ?? '').toLowerCase() != _filtroEstado.toLowerCase()) return false;
      }
      if (_filtroDoctor != 'Todos los doctores') {
        if ((cita['doctor'] as String? ?? '').toLowerCase() != _filtroDoctor.toLowerCase()) return false;
      }
      if (_filtroFecha != null && _filtroFecha!.isNotEmpty) {
        if ((cita['fecha'] as String? ?? '') != _filtroFecha) return false;
      }
      return true;
    }).toList();
  }

  Map<String, int> _calcularMetricas() {
    int programadas = 0, completadas = 0, canceladas = 0, noAsistio = 0;
    for (var cita in listaCitas) {
      final estado = cita['estado'] as String? ?? '';
      if (estado == 'Programada') programadas++;
      if (estado == 'Completada') completadas++;
      if (estado == 'Cancelada') canceladas++;
      if (estado == 'No asistió') noAsistio++;
    }
    return {
      'total': listaCitas.length,
      'programadas': programadas,
      'completadas': completadas,
      'canceladas': canceladas,
      'noAsistio': noAsistio,
    };
  }

  Future<void> _seleccionarFechaFiltro() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final dia = picked.day.toString().padLeft(2, '0');
      final mes = picked.month.toString().padLeft(2, '0');
      final anio = picked.year.toString();
      setState(() => _filtroFecha = '$dia/$mes/$anio');
    }
  }

  void _filtrarHoy() {
    final now = DateTime.now();
    final dia = now.day.toString().padLeft(2, '0');
    final mes = now.month.toString().padLeft(2, '0');
    final anio = now.year.toString();
    setState(() => _filtroFecha = '$dia/$mes/$anio');
  }

  void _limpiarFiltros() {
    setState(() {
      _searchController.clear();
      _filtroEstado = 'Todos los estados';
      _filtroDoctor = 'Todos los doctores';
      _filtroFecha = null;
    });
  }

  void _abrirModalCita([Map<String, dynamic>? cita]) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CitaModal(
          id: cita?['id'] as String?,
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
                final nuevoNumero = listaCitas.length + 1;
                final nuevoCodigo = 'CIT-${nuevoNumero.toString().padLeft(3, '0')}';
                listaCitas.insert(0, {
                  'id': nuevoCodigo,
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
                content: Text(
                  cita != null ? 'Cita actualizada correctamente' : 'Cita agendada correctamente',
                ),
                backgroundColor: Colors.blue[700],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rol = perfilUsuarioActual['rol'] as String? ?? 'Administrador';
    final bool esAdmin = rol == 'Administrador';
    final metricas = _calcularMetricas();
    final citasMostradas = _obtenerCitasFiltradas();

    final List<String> doctoresFiltro = [
      'Todos los doctores',
      ...listaDoctores.map((d) => d['nombre'] as String).toSet(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: const DentalLogo(),
        actions: const [UserBadge()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.calendar_month, color: Colors.blue[700], size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agenda de Citas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        esAdmin
                            ? 'Administra las citas registradas entre pacientes y doctores.'
                            : 'Consulta de citas programadas en la clínica.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Métricas (siguiendo el estándar de servicios_screen)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMetricaItem(Colors.amber[700]!, 'Total:', ' ${metricas['total']}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.blue[600]!, 'Programadas:', ' ${metricas['programadas']}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.green[600]!, 'Completadas:', ' ${metricas['completadas']}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.red[600]!, 'Canceladas:', ' ${metricas['canceladas']}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.amber[800]!, 'No asistió:', ' ${metricas['noAsistio']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buscador
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  hintText: 'Buscar por paciente o motivo...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filtros Fila 1: Fecha y Estado
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _seleccionarFechaFiltro,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _filtroFecha ?? 'dd/mm/aaaa',
                              style: TextStyle(
                                fontSize: 13,
                                color: _filtroFecha != null ? Colors.black87 : Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_filtroFecha != null)
                            InkWell(
                              onTap: () => setState(() => _filtroFecha = null),
                              child: const Icon(Icons.close, size: 14, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _buildDropdownFiltro(
                  valor: _filtroEstado,
                  opciones: _estados,
                  onChanged: (val) {
                    if (val != null) setState(() => _filtroEstado = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Filtros Fila 2: Doctor, Hoy, Limpiar
            Row(
              children: [
                _buildDropdownFiltro(
                  valor: _filtroDoctor,
                  opciones: doctoresFiltro,
                  onChanged: (val) {
                    if (val != null) setState(() => _filtroDoctor = val);
                  },
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _filtrarHoy,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                    child: Text('Hoy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: _limpiarFiltros,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                    child: Text('Limpiar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Encabezado de Citas Registradas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CITAS REGISTRADAS',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700], letterSpacing: 0.5),
                ),
                Text('${citasMostradas.length} mostradas', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
            const SizedBox(height: 12),

            // Listado de Tarjetas
            if (citasMostradas.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text('No se encontraron citas registradas', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
              )
            else
              for (var cita in citasMostradas)
                _buildCitaCard(cita: cita, esAdmin: esAdmin),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: esAdmin
          ? FloatingActionButton(
              onPressed: () => _abrirModalCita(),
              backgroundColor: Colors.blue[700],
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: (rol == 'Recepcionista' || rol == 'Doctor') ? 1 : 3,
      ),
    );
  }

  Widget _buildDropdownFiltro({
    required String valor,
    required List<String> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: opciones.contains(valor) ? valor : opciones.first,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 18),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            items: opciones.map((op) {
              return DropdownMenuItem<String>(
                value: op,
                child: Text(op, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildSeparadorVertical() {
    return Container(
      height: 14,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey[300],
    );
  }

  Widget _buildMetricaItem(Color puntoColor, String etiqueta, String valor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: puntoColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(etiqueta, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        Text(valor, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildCitaCard({
    required Map<String, dynamic> cita,
    required bool esAdmin,
  }) {
    final String codigo = cita['codigo'] as String? ?? cita['id'] as String? ?? 'CIT-000';
    final String estado = cita['estado'] as String? ?? 'Programada';
    final String paciente = cita['paciente'] as String? ?? 'Paciente';
    final String pacienteId = cita['pacienteId'] as String? ?? '1';
    final String motivo = cita['motivo'] as String? ?? 'Consulta general';
    final String doctor = cita['doctor'] as String? ?? 'Doctor';
    final String fecha = cita['fecha'] as String? ?? '';
    final String hora = cita['hora'] as String? ?? '';

    final (Color estadoPillBg, Color estadoPillTexto, Color estadoPillDot, IconData leadingIcon, Color leadingColor) =
        switch (estado) {
      'No asistió' => (
          const Color(0xFFFEF7E0),
          const Color(0xFFB06000),
          Colors.amber[700]!,
          Icons.access_time,
          Colors.amber[800]!,
        ),
      'Cancelada' => (
          Colors.red[50]!,
          Colors.red[700]!,
          Colors.red[600]!,
          Icons.cancel_outlined,
          Colors.red[600]!,
        ),
      'Completada' => (
          Colors.green[50]!,
          Colors.green[700]!,
          Colors.green[600]!,
          Icons.check_circle_outline,
          Colors.green[600]!,
        ),
      _ => (
          Colors.blue[50]!,
          Colors.blue[700]!,
          Colors.blue[600]!,
          Icons.calendar_today_outlined,
          Colors.blue[600]!,
        ),
    };

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: esAdmin ? () => _abrirModalCita(cita) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    codigo,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal[700]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: estadoPillBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: estadoPillDot, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        estado,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: estadoPillTexto),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: leadingColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(leadingIcon, color: leadingColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PACIENTE:',
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Colors.grey[500], letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 1),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$paciente ',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            TextSpan(
                              text: '(ID: $pacienteId)',
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          motivo,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blue[700]),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'DOCTOR: ',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                            ),
                            TextSpan(
                              text: doctor,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Text('📅 ', style: TextStyle(fontSize: 10.5)),
                          Text('$fecha • ', style: TextStyle(fontSize: 11.5, color: Colors.grey[700])),
                          Text(
                            hora,
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
