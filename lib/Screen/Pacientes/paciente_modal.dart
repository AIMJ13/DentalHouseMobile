import 'package:flutter/material.dart';
import '../../Widget/custom_bottom_modal.dart';
import '../../Widget/custom_text_field.dart';
import '../../Widget/estado_toggle.dart';

class PacienteModal extends StatefulWidget {
  final String? id;
  final String? nombre;
  final String? apellido;
  final String? telefono;
  final String? direccion;
  final String? fechaNacimiento;
  final bool activo;
  final void Function(
    String nombre,
    String apellido,
    String telefono,
    String direccion,
    String fechaNacimiento,
    bool activo,
  )? onGuardar;

  const PacienteModal({
    super.key,
    this.id,
    this.nombre,
    this.apellido,
    this.telefono,
    this.direccion,
    this.fechaNacimiento,
    this.activo = true,
    this.onGuardar,
  });

  @override
  State<PacienteModal> createState() => _PacienteModalState();
}

class _PacienteModalState extends State<PacienteModal> {
  late final TextEditingController _nombreController;
  late final TextEditingController _apellidoController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _direccionController;
  late final TextEditingController _fechaNacimientoController;
  late bool _esActivo;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre ?? '');
    _apellidoController = TextEditingController(text: widget.apellido ?? '');
    _telefonoController = TextEditingController(text: widget.telefono ?? '');
    _direccionController = TextEditingController(text: widget.direccion ?? '');
    _fechaNacimientoController = TextEditingController(text: widget.fechaNacimiento ?? '');
    _esActivo = widget.activo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fechaActual = DateTime.now();
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1920),
      lastDate: fechaActual,
    );

    if (fechaSeleccionada != null) {
      final dia = fechaSeleccionada.day.toString().padLeft(2, '0');
      final mes = fechaSeleccionada.month.toString().padLeft(2, '0');
      final anio = fechaSeleccionada.year.toString();
      setState(() {
        _fechaNacimientoController.text = '$dia/$mes/$anio';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomModal(
      icono: widget.id == null ? Icons.person_add_alt_1_outlined : Icons.edit_outlined,
      titulo: widget.id == null ? 'Nuevo Paciente' : 'Editar Paciente',
      subtitulo: widget.id == null
          ? 'Registra los datos personales y de contacto del paciente.'
          : 'Modifica la información y estado del paciente.',
      textoConfirmar: widget.id == null ? 'Guardar' : 'Actualizar Paciente',
      onConfirmar: () {
        final nombre = _nombreController.text.trim();
        final apellido = _apellidoController.text.trim();
        final telefono = _telefonoController.text.trim();
        final direccion = _direccionController.text.trim();
        final fechaNacimiento = _fechaNacimientoController.text.trim();

        if (nombre.isEmpty || apellido.isEmpty) return;

        Navigator.pop(context);
        if (widget.onGuardar != null) {
          widget.onGuardar!(
            nombre,
            apellido,
            telefono,
            direccion,
            fechaNacimiento,
            _esActivo,
          );
        }
      },
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'Nombre',
            hintText: 'Ejemplo: Juan',
            controller: _nombreController,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Apellido',
            hintText: 'Ejemplo: Pérez',
            controller: _apellidoController,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Teléfono',
            hintText: 'Ejemplo: 809-555-1001',
            controller: _telefonoController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Dirección',
            hintText: 'Ejemplo: Managua, Nicaragua',
            controller: _direccionController,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Fecha de nacimiento',
            hintText: 'dd/mm/aaaa',
            controller: _fechaNacimientoController,
            keyboardType: TextInputType.datetime,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_month_outlined, color: Colors.grey[600], size: 20),
              onPressed: () => _seleccionarFecha(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.id == null ? 'Estado inicial' : 'Estado',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          EstadoToggle(
            valor: _esActivo,
            onChanged: (val) {
              setState(() {
                _esActivo = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
