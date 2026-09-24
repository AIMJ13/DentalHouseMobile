import 'package:flutter/material.dart';
import 'recepcion_citas_screen.dart';

class EditarCitaDialog extends StatefulWidget {
  final Cita cita;

  const EditarCitaDialog({super.key, required this.cita});

  @override
  State<EditarCitaDialog> createState() => _EditarCitaDialogState();
}

class _EditarCitaDialogState extends State<EditarCitaDialog> {
  late TextEditingController _motivoController;
  late TextEditingController _fechaController;
  late TextEditingController _horaController;

  @override
  void initState() {
    super.initState();
    _motivoController = TextEditingController(text: widget.cita.motivo);
    _fechaController = TextEditingController();
    _horaController = TextEditingController();
  }

  @override
  void dispose() {
    _motivoController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    super.dispose();
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
                  const Text(
                    'Editar Cita',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Text(
                'Modifique los datos de la cita registrada.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              const Text('Paciente', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: widget.cita.paciente,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [widget.cita.paciente]
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              const Text('Doctor', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: widget.cita.doctor,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [widget.cita.doctor]
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (value) {},
              ),
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
                              _fechaController.text =
                                  '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
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
                              _horaController.text = hora.format(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
