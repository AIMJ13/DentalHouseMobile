import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';
import 'custom_text_field.dart';

Future<void> showPacienteFormDialog(
  BuildContext context, {
  required bool esEdicion,
  String? nombreInicial,
  String? apellidoInicial,
  String? telefonoInicial,
  String? direccionInicial,
  String? nacimientoInicial,
  String? estadoInicial,
  void Function(Map<String, String> datos)? onGuardar,
}) {
  final nombreController = TextEditingController(text: nombreInicial ?? '');
  final apellidoController = TextEditingController(text: apellidoInicial ?? '');
  final telefonoController = TextEditingController(text: telefonoInicial ?? '');
  final direccionController = TextEditingController(text: direccionInicial ?? '');
  final nacimientoController =
      TextEditingController(text: nacimientoInicial ?? '');
  String estadoSeleccionado = estadoInicial ?? 'Activo';

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // NUEVO ENCABEZADO ESTILO ADMINISTRADOR
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.person_add_alt_1, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                esEdicion ? 'Editar Paciente' : 'Nuevo Paciente',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                esEdicion
                                    ? 'Modifique los datos del paciente.'
                                    : 'Registra los datos personales y de contacto del paciente.',
                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: const Icon(Icons.close, size: 18, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Nombre',
                      hintText: 'Ejemplo: Juan',
                      controller: nombreController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Apellido',
                      hintText: 'Ejemplo: Pérez',
                      controller: apellidoController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Teléfono',
                      hintText: 'Ejemplo: 809-555-1001',
                      controller: telefonoController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Dirección',
                      hintText: 'Ejemplo: Managua, Nicaragua',
                      controller: direccionController,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Fecha de nacimiento',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nacimientoController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'dd/mm/aaaa',
                        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      onTap: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(),
                        );
                        if (fecha != null) {
                          nacimientoController.text =
                              '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
                        }
                      },
                    ),
                    
                    if (esEdicion) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Estado',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: estadoSeleccionado,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                          DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                        ],
                        onChanged: (valor) {
                          setStateDialog(() {
                            estadoSeleccionado = valor ?? 'Activo';
                          });
                        },
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.black87, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              onGuardar?.call({
                                'nombre': nombreController.text,
                                'apellido': apellidoController.text,
                                'telefono': telefonoController.text,
                                'direccion': direccionController.text,
                                'nacimiento': nacimientoController.text,
                                'estado': esEdicion ? estadoSeleccionado : 'Activo',
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              esEdicion ? 'Actualizar' : 'Guardar',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}