import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/confirm_dialog.dart';
import '../../Widget/custom_bottom_modal.dart';
import '../../Widget/custom_select_modal.dart';
import '../../Widget/custom_text_field.dart';

class CitaModal extends StatefulWidget {
  final String? id;
  final String? codigo;
  final String? paciente;
  final String? pacienteId;
  final String? motivo;
  final String? doctor;
  final String? fecha;
  final String? hora;
  final String? estado;
  final void Function({
    required String paciente,
    required String pacienteId,
    required String motivo,
    required String doctor,
    required String fecha,
    required String hora,
    required String estado,
  })? onGuardar;

  const CitaModal({
    super.key,
    this.id,
    this.codigo,
    this.paciente,
    this.pacienteId,
    this.motivo,
    this.doctor,
    this.fecha,
    this.hora,
    this.estado,
    this.onGuardar,
  });

  @override
  State<CitaModal> createState() => _CitaModalState();
}

class _CitaModalState extends State<CitaModal> {
  late String _pacienteSeleccionado;
  late String _doctorSeleccionado;
  late String _estadoSeleccionado;
  late final TextEditingController _fechaController;
  late final TextEditingController _horaController;
  late final TextEditingController _motivoController;
  bool _confirmadoCancelar = false;

  bool get _esEdicion => widget.id != null || widget.codigo != null;

  @override
  void initState() {
    super.initState();
    final pacientes = listaPacientes.map((p) => '${p['nombre']} ${p['apellido']}'.trim()).toList();
    _pacienteSeleccionado = widget.paciente ?? (pacientes.isNotEmpty ? pacientes.first : 'Carlos Morales');

    final doctores = listaDoctores.map((d) => d['nombre'] as String).toList();
    _doctorSeleccionado = widget.doctor ?? (doctores.isNotEmpty ? doctores.first : 'Dra. María González');

    _estadoSeleccionado = widget.estado ?? 'Programada';

    final now = DateTime.now();
    final dia = now.day.toString().padLeft(2, '0');
    final mes = now.month.toString().padLeft(2, '0');
    final anio = now.year.toString();

    _fechaController = TextEditingController(text: widget.fecha ?? '$dia/$mes/$anio');
    _horaController = TextEditingController(text: widget.hora ?? '09:00 AM');
    _motivoController = TextEditingController(text: widget.motivo ?? '');
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _horaController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
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
      setState(() => _fechaController.text = '$dia/$mes/$anio');
    }
  }

  Future<void> _seleccionarHora(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() => _horaController.text = picked.format(context));
    }
  }

  void _guardar() {
    final paciente = _pacienteSeleccionado;
    final doctor = _doctorSeleccionado;
    final fecha = _fechaController.text.trim();
    final hora = _horaController.text.trim();
    final motivo = _motivoController.text.trim();

    if (paciente.isEmpty || doctor.isEmpty) return;

    String pacienteId = widget.pacienteId ?? '1';
    for (var pac in listaPacientes) {
      final fullNombre = '${pac['nombre']} ${pac['apellido']}'.trim();
      if (fullNombre.toLowerCase() == paciente.toLowerCase()) {
        final idStr = pac['id'].toString();
        pacienteId = idStr.replaceAll(RegExp(r'[^0-9]'), '');
        if (pacienteId.isEmpty) pacienteId = '1';
        break;
      }
    }

    Navigator.pop(context);
    widget.onGuardar?.call(
      paciente: paciente,
      pacienteId: pacienteId,
      motivo: motivo.isNotEmpty ? motivo : 'Consulta general',
      doctor: doctor,
      fecha: fecha.isNotEmpty ? fecha : '28/10/2026',
      hora: hora.isNotEmpty ? hora : '09:00 AM',
      estado: _estadoSeleccionado,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pacientesNombres = listaPacientes.map((p) => '${p['nombre']} ${p['apellido']}'.trim()).toList();
    if (!pacientesNombres.contains(_pacienteSeleccionado)) {
      pacientesNombres.insert(0, _pacienteSeleccionado);
    }

    final doctoresNombres = listaDoctores.map((d) => d['nombre'] as String).toList();
    if (!doctoresNombres.contains(_doctorSeleccionado)) {
      doctoresNombres.insert(0, _doctorSeleccionado);
    }

    return CustomBottomModal(
      icono: _esEdicion ? Icons.edit_calendar_outlined : Icons.calendar_month_outlined,
      titulo: _esEdicion ? 'Editar Cita' : 'Agendar Cita',
      badgeTexto: widget.codigo ?? widget.id,
      subtitulo: _esEdicion
          ? 'Modifique los datos de la cita registrada'
          : 'Complete los datos para registrar una nueva cita',
      textoConfirmar: _esEdicion ? 'Guardar Cambios' : 'Agendar Cita',
      onConfirmar: _guardar,
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSelectModal(
            label: 'Paciente',
            valorSeleccionado: _pacienteSeleccionado,
            opciones: pacientesNombres,
            onSeleccionado: (val) => setState(() => _pacienteSeleccionado = val),
          ),
          const SizedBox(height: 12),
          CustomSelectModal(
            label: 'Doctor',
            valorSeleccionado: _doctorSeleccionado,
            opciones: doctoresNombres,
            onSeleccionado: (val) => setState(() => _doctorSeleccionado = val),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Fecha',
                  hintText: 'dd/mm/aaaa',
                  controller: _fechaController,
                  keyboardType: TextInputType.datetime,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_month_outlined, color: Colors.blue[700], size: 20),
                    onPressed: () => _seleccionarFecha(context),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  label: 'Hora',
                  hintText: 'hh:mm',
                  controller: _horaController,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time, color: Colors.blue[700], size: 20),
                    onPressed: () => _seleccionarHora(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Motivo / Tratamiento',
            hintText: 'Describa el motivo o tratamiento...',
            controller: _motivoController,
          ),
          if (_esEdicion) ...[
            const SizedBox(height: 12),
            CustomSelectModal(
              label: 'Estado de la Cita',
              valorSeleccionado: _estadoSeleccionado,
              opciones: const [
                'Programada',
                'Completada',
                'Cancelada',
                'No asistió',
              ],
              onSeleccionado: (val) {
                if (val == 'Cancelada' && !_confirmadoCancelar) {
                  showDialog(
                    context: context,
                    builder: (ctx) => ConfirmDialog(
                      titulo: '¿Cancelar Cita?',
                      subtitulo: 'Confirmar cambio de estado',
                      advertencia: 'La cita quedará registrada como Cancelada en el sistema.',
                      textoConfirmar: 'Sí, Cancelar',
                      colorBotonConfirmar: Colors.red[600],
                      icono: Icons.warning_amber_rounded,
                      colorIcono: Colors.red[600],
                      colorFondoIcono: Colors.red[50],
                      contenido: Text(
                        'Paciente: $_pacienteSeleccionado',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      onConfirmar: () {
                        setState(() {
                          _estadoSeleccionado = 'Cancelada';
                          _confirmadoCancelar = true;
                        });
                      },
                    ),
                  );
                } else {
                  setState(() => _estadoSeleccionado = val);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
