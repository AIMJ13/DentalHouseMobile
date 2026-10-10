import 'package:flutter/material.dart';
import 'recepcion_citas_screen.dart';

class EditarCitaDialog extends StatefulWidget {
  final Cita cita;
  final bool esReagendar;
  final String? Function(String fecha, String hora)? validarChoque;
  final void Function(String motivo, String fecha, String hora)? onGuardar;

  const EditarCitaDialog({
    super.key,
    required this.cita,
    this.validarChoque,
    this.onGuardar,
    this.esReagendar = false,
  });

  @override
  State<EditarCitaDialog> createState() => _EditarCitaDialogState();
}

class _EditarCitaDialogState extends State<EditarCitaDialog> {
  late TextEditingController _motivoController;
  late TextEditingController _fechaController;
  late TextEditingController _horaController;
  String? _errorHorario;

  @override
  void initState() {
    super.initState();
    _motivoController = TextEditingController(text: widget.cita.motivo);
    _fechaController = TextEditingController(text: widget.esReagendar ? '' : widget.cita.fecha);
    _horaController = TextEditingController(text: widget.esReagendar ? '' : widget.cita.hora);
  }

  @override
  void dispose() {
    _motivoController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  void _guardar() {
    final fecha = _fechaController.text.trim();
    final hora = _horaController.text.trim();
    final motivo = _motivoController.text.trim();

    if (fecha.isEmpty || hora.isEmpty) {
      setState(() {
        _errorHorario = 'Selecciona fecha y hora de la cita.';
      });
      return;
    }

    final error = widget.validarChoque?.call(fecha, hora);
    if (error != null) {
      setState(() {
        _errorHorario = error;
      });
      return;
    }

    Navigator.of(context).pop();
    widget.onGuardar?.call(motivo, fecha, hora);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.esReagendar ? 'Reagendar Cita' : 'Editar Cita',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Text(
                widget.esReagendar
                    ? 'Selecciona una nueva fecha y hora para la cita.'
                    : 'Modifique los datos de la cita registrada.',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              Text('Paciente: ${widget.cita.paciente}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Doctor: ${widget.cita.doctor}', style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _fechaController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'dd/mm/aaaa',
                            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onTap: () async {
                            final fecha = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (fecha != null) {
                              setState(() {
                                _fechaController.text =
                                    '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
                                _errorHorario = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hora', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _horaController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '--:--',
                            suffixIcon: const Icon(Icons.access_time, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onTap: () async {
                            final hora = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (hora != null && context.mounted) {
                              setState(() {
                                _horaController.text = hora.format(context);
                                _errorHorario = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_errorHorario != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorHorario!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),

              const Text('Motivo de la cita', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(
                controller: _motivoController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ejemplo: Consulta general, dolor dental...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _guardar,
                  child: Text(
                    widget.esReagendar ? 'Reagendar' : 'Guardar cambios',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}