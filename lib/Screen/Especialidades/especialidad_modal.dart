import 'package:flutter/material.dart';
import '../../Widget/custom_bottom_modal.dart';
import '../../Widget/custom_text_field.dart';

class EspecialidadModal extends StatefulWidget {
  final String? id;
  final String? nombre;
  final String? descripcion;
  final bool activo;
  final void Function(String nombre, String descripcion, bool activo)? onGuardar;

  const EspecialidadModal({
    super.key,
    this.id,
    this.nombre,
    this.descripcion,
    this.activo = true,
    this.onGuardar,
  });

  @override
  State<EspecialidadModal> createState() => _EspecialidadModalState();
}

class _EspecialidadModalState extends State<EspecialidadModal> {
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late bool _esActivo;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.descripcion ?? '');
    _esActivo = widget.activo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomModal(
      icono: widget.id == null ? Icons.add_circle_outline : Icons.edit_outlined,
      titulo: widget.id == null ? 'Añadir Especialidad' : 'Editar Especialidad',
      subtitulo: widget.id == null
          ? 'Registra una nueva especialidad médica en el sistema.'
          : 'Modifica la información y estado de la especialidad en el sistema.',
      textoConfirmar: widget.id == null ? 'Guardar Especialidad' : 'Guardar Cambios',
      onConfirmar: () {
        final nombre = _nombreController.text.trim();
        final descripcion = _descripcionController.text.trim();
        if (nombre.isEmpty) return;
        Navigator.pop(context);
        if (widget.onGuardar != null) {
          widget.onGuardar!(nombre, descripcion, _esActivo);
        }
      },
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Nombre de la Especialidad',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
              ),
              Text(
                '*Requerido',
                style: TextStyle(fontSize: 11, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 6),
          CustomTextField(
            hintText: 'Ej. Odontopediatría',
            controller: _nombreController,
          ),
        ],
      ),
    );
  }
}
