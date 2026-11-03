import 'package:flutter/material.dart';
import '../../../data/models/patient_model.dart';
import '../../widgets/custom_bottom_modal.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/estado_toggle.dart';

class PacienteModal extends StatefulWidget {
  final PatientModel? paciente;
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
    this.paciente,
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

  bool get _esEdicion => widget.paciente != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.paciente?.firstName ?? '');
    _apellidoController = TextEditingController(text: widget.paciente?.lastName ?? '');
    _telefonoController = TextEditingController(text: widget.paciente?.phone ?? '');
    _direccionController = TextEditingController(text: widget.paciente?.address ?? '');
    _fechaNacimientoController = TextEditingController(
      text: widget.paciente != null ? widget.paciente!.birthDate.split(' ')[0] : '',
    );
    _esActivo = widget.paciente?.isActive ?? true;
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
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final dia = picked.day.toString().padLeft(2, '0');
      final mes = picked.month.toString().padLeft(2, '0');
      final anio = picked.year.toString();
      setState(() {
        _fechaNacimientoController.text = '$anio-$mes-$dia';
      });
    }
  }

  void _confirmar() {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final telefono = _telefonoController.text.trim();
    final direccion = _direccionController.text.trim();
    final fecha = _fechaNacimientoController.text.trim();

    if (nombre.isEmpty || apellido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre y el apellido son requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context);
    widget.onGuardar?.call(
      nombre,
      apellido,
      telefono,
      direccion,
      fecha.isNotEmpty ? fecha : '1995-01-01',
      _esActivo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomModal(
      icono: _esEdicion ? Icons.edit_outlined : Icons.person_add_alt_1_outlined,
      titulo: _esEdicion ? 'Editar Paciente' : 'Nuevo Paciente',
      badgeTexto: _esEdicion ? widget.paciente!.code : null,
      subtitulo: _esEdicion
          ? 'Modifica la información y estado del paciente.'
          : 'Registra los datos personales y de contacto del paciente.',
      textoConfirmar: _esEdicion ? 'Actualizar Paciente' : 'Guardar',
      onConfirmar: _confirmar,
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
            hintText: 'aaaa-mm-dd',
            controller: _fechaNacimientoController,
            keyboardType: TextInputType.datetime,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_month_outlined, color: Colors.grey[600], size: 20),
              onPressed: () => _seleccionarFecha(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _esEdicion ? 'Estado' : 'Estado inicial',
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
