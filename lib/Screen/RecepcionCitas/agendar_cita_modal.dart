import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/custom_button.dart';

class AgendarCitaModal extends StatefulWidget {
  const AgendarCitaModal({super.key});

  @override
  State<AgendarCitaModal> createState() => _AgendarCitaModalState();
}

class _AgendarCitaModalState extends State<AgendarCitaModal> {
  String? _pacienteSeleccionado;
  String? _doctorSeleccionado;
  final TextEditingController _motivoController = TextEditingController();

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Agendar Cita',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Text(
                'Complete los datos de la cita.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              const Text('Paciente', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _pacienteSeleccionado,
                    isExpanded: true,
                    hint: const Text('Seleccione un paciente'),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: [
                      for (var pac in listaPacientes)
                        DropdownMenuItem(
                          value: '${pac['nombre']} ${pac['apellido']}',
                          child: Text('${pac['nombre']} ${pac['apellido']}'),
                        ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _pacienteSeleccionado = val;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Doctor', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _doctorSeleccionado,
                    isExpanded: true,
                    hint: const Text('Seleccione un doctor'),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    selectedItemBuilder: (context) {
                      return listaDoctores.map((doc) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(doc['nombre'] as String),
                        );
                      }).toList();
                    },
                    items: [
                      for (var doc in listaDoctores)
                        DropdownMenuItem(
                          value: doc['nombre'] as String,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.blue[50],
                                child: Text(
                                  (doc['nombre'] as String)
                                      .replaceAll('Dr. ', '')
                                      .replaceAll('Dra. ', '')
                                      .split(' ')
                                      .map((s) => s.isNotEmpty ? s[0] : '')
                                      .take(2)
                                      .join(),
                                  style: TextStyle(fontSize: 11, color: Colors.blue[700], fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(doc['nombre'] as String, style: const TextStyle(fontSize: 14)),
                                    Text(
                                      doc['especialidad'] as String,
                                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              if (_doctorSeleccionado == doc['nombre'])
                                Icon(Icons.check, color: Colors.blue[700], size: 18),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _doctorSeleccionado = val;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Motivo de la cita', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: _motivoController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ejemplo: Consulta general, dolor dental, control...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'Guardar Cita',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}