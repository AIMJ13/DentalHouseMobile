import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

// Muestra el formulario de Nuevo Paciente o Editar Paciente.
// Se reutiliza el mismo diálogo para ambos casos, cambiando el título,
// el texto del botón y si los campos vienen o no con datos precargados.
Future<void> showPacienteFormDialog(
  BuildContext context, {
  required bool esEdicion,
  String? nombreInicial,
  String? apellidoInicial,
  String? telefonoInicial,
  String? direccionInicial,
  String? nacimientoInicial,
  String? estadoInicial,
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
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  esEdicion ? 'Editar Paciente' : 'Nuevo Paciente',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
                CustomTextField(
                  label: 'Fecha de nacimiento',
                  hintText: 'dd/mm/aaaa',
                  controller: nacimientoController,
                ),
                // El estado (Activo/Inactivo) solo tiene sentido al editar.
                // Un paciente nuevo siempre entra como Activo por defecto.
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
                      estadoSeleccionado = valor ?? 'Activo';
                    },
                  ),
                ],
                const SizedBox(height: 20),
                CustomButton(
                  // Misma lógica en todos los formularios:
                  // crear = "Guardar", editar = "Actualizar".
                  text: esEdicion ? 'Actualizar' : 'Guardar',
                  color: AppColors.primary,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}