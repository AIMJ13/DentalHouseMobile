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
import 'agendar_cita_modal.dart';
import '../RecepcionCitas/editar_cita_modal.dart';
import '../RecepcionCitas/recepcion_citas_screen.dart' show Cita;

class AgendaCitasScreen extends StatefulWidget {
  const AgendaCitasScreen({super.key});

  @override
  State<AgendaCitasScreen> createState() => _AgendaCitasScreenState();
}

class _AgendaCitasScreenState extends State<AgendaCitasScreen> {
  late List<Map<String, String>> _citas;

  final TextEditingController _busquedaController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  String _busqueda = '';
  String _estadoFiltro = 'Todos';
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _citas = citasRegistradas.map((c) => Map<String, String>.from(c)).toList();
    _busquedaController.addListener(() {
      setState(() {
        _busqueda = _busquedaController.text;
      });
    });
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    _fechaController.dispose();
    super.dispose();
  }


  StatusType _tipoDesdeEstado(String estado) {
    switch (estado) {
      case 'Programada':
        return StatusType.info;
      case 'Completada':
        return StatusType.success;
      case 'Cancelada':
        return StatusType.danger;
      case 'No asistió':
        return StatusType.warning;
      default:
        return StatusType.neutral;
    }
  }

  String _accionTextoPara(String estado) {
    switch (estado) {
      case 'Programada':
        return 'Cancelar';
      case 'Cancelada':
        return 'Reactivar';
      case 'No asistió':
        return 'Reagendar';
      default:
        return 'Cancelar';
    }
  }

  Color _accionColorPara(String estado) {
    switch (estado) {
      case 'Programada':
        return AppColors.danger;
      case 'Cancelada':
        return AppColors.success;
      default:
        return Colors.white;
    }
  }

  Color _accionTextColorPara(String estado) {
    return _accionColorPara(estado) == Colors.white
        ? AppColors.textDark
        : Colors.white;
  }


  void _cambiarEstado(String codigo, String nuevoEstado) {
    setState(() {
      final index = _citas.indexWhere((c) => c['codigo'] == codigo);
      if (index != -1) {
        _citas[index]['estado'] = nuevoEstado;
      }
    });
  }

  void _onAccionSecundaria(String codigo, String estadoActual) {
    switch (estadoActual) {
      case 'Programada':
        _cambiarEstado(codigo, 'Cancelada');
        break;
      case 'Cancelada':
        _cambiarEstado(codigo, 'Programada');
        break;
      case 'No asistió':
        _cambiarEstado(codigo, 'Programada');
        break;
    }
  }


  bool _mismaFecha(String fechaTexto, DateTime fecha) {
    final partes = fechaTexto.split('/');
    if (partes.length != 3) return false;
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final anio = int.tryParse(partes[2]);
    return dia == fecha.day && mes == fecha.month && anio == fecha.year;
  }

  Future<void> _elegirFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
        _fechaController.text =
            '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
      });
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _busquedaController.clear();
      _fechaController.clear();
      _estadoFiltro = 'Todos';
      _fechaSeleccionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final citasFiltradas = _citas.where((c) {
      final coincideEstado =
          _estadoFiltro == 'Todos' || c['estado'] == _estadoFiltro;
      final texto = _busqueda.toLowerCase();
      final coincideBusqueda = c['paciente']!.toLowerCase().contains(texto) ||
          c['motivo']!.toLowerCase().contains(texto);
      final coincideFecha = _fechaSeleccionada == null ||
          _mismaFecha(c['fecha']!, _fechaSeleccionada!);
      return coincideEstado && coincideBusqueda && coincideFecha;
    }).toList();

    final resumen = [
      {'etiqueta': 'Total', 'valor': _citas.length.toString(), 'tipo': 'neutral'},
      {
        'etiqueta': 'Programadas',
        'valor': _citas.where((c) => c['estado'] == 'Programada').length.toString(),
        'tipo': 'info',
      },
      {
        'etiqueta': 'Completadas',
        'valor': _citas.where((c) => c['estado'] == 'Completada').length.toString(),
        'tipo': 'success',
      },
      {
        'etiqueta': 'Canceladas',
        'valor': _citas.where((c) => c['estado'] == 'Cancelada').length.toString(),
        'tipo': 'danger',
      },
      {
        'etiqueta': 'No asistió',
        'valor': _citas.where((c) => c['estado'] == 'No asistió').length.toString(),
        'tipo': 'warning',
      },
    ];

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
            StatsSummaryRow(items: resumen),
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
                  child: TextField(
                    controller: _fechaController,
                    readOnly: true,
                    onTap: _elegirFecha,
                    decoration: InputDecoration(
                      hintText: 'dd/mm/aaaa',
                      hintStyle: const TextStyle(color: AppColors.textGrey),
                      prefixIcon: const Icon(Icons.calendar_today,
                          size: 16, color: AppColors.textGrey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      final hoy = DateTime.now();
                      _fechaSeleccionada = hoy;
                      _fechaController.text =
                          '${hoy.day.toString().padLeft(2, '0')}/${hoy.month.toString().padLeft(2, '0')}/${hoy.year}';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Hoy',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _limpiarFiltros,
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
            ...citasFiltradas.map((c) {
              final estadoActual = c['estado']!;
              return CitaRegistradaCard(
                codigo: c['codigo']!,
                estado: estadoActual,
                estadoTipo: _tipoDesdeEstado(estadoActual),
                paciente: c['paciente']!,
                pacienteId: c['pacienteId']!,
                motivo: c['motivo']!,
                doctor: c['doctor']!,
                fecha: c['fecha']!,
                hora: c['hora']!,
                accionSecundariaTexto: _accionTextoPara(estadoActual),
                accionSecundariaColor: _accionColorPara(estadoActual),
                accionSecundariaTextColor: _accionTextColorPara(estadoActual),
                accionTerciariaTexto:
                    estadoActual == 'Programada' ? 'Completar' : null,
                onAccionTerciaria: estadoActual == 'Programada'
                    ? () => _cambiarEstado(c['codigo']!, 'Completada')
                    : null,
                onEditar: () {
                  final cita = Cita(
                    codigo: c['codigo']!,
                    paciente: c['paciente']!,
                    motivo: c['motivo']!,
                    doctor: c['doctor']!,
                    fechaHora: '${c['fecha']} • ${c['hora']}',
                    estado: estadoActual,
                  );
                  showDialog(
                    context: context,
                    builder: (context) => EditarCitaDialog(cita: cita),
                  );
                },
                onAccionSecundaria: () =>
                    _onAccionSecundaria(c['codigo']!, estadoActual),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AgendarCitaDialog(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const DoctorBottomNav(currentIndex: 1),
    );
  }
}