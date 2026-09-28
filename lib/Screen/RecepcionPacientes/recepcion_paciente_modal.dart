import 'package:flutter/material.dart';
import '../../Widget/custom_bottom_modal.dart';
import '../../Widget/custom_text_field.dart';
import '../../Widget/estado_toggle.dart';
import '../../Widget/confirm_dialog.dart';

class RecepcionPacienteModal extends StatefulWidget {
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

  const RecepcionPacienteModal({
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
  State<RecepcionPacienteModal> createState() => _RecepcionPacienteModalState();
}

class _RecepcionPacienteModalState extends State<RecepcionPacienteModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  void _validarYConfirmar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final telefono = _telefonoController.text.trim();
    final direccion = _direccionController.text.trim();
    final fechaNacimiento = _fechaNacimientoController.text.trim();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          titulo: widget.id == null ? '¿Guardar Paciente?' : '¿Actualizar Paciente?',
          subtitulo: '$nombre $apellido',
          icono: Icons.check_circle_outline,
          colorIcono: Colors.blue[700],
          colorFondoIcono: Colors.blue[50],
          colorAdvertencia: Colors.blue[800],
          colorFondoAdvertencia: Colors.blue[50],
          colorBotonConfirmar: Colors.blue[700],
          textoConfirmar: 'Sí, Guardar',
          advertencia: 'Se guardarán los datos ingresados del paciente en el sistema.',
          contenido: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teléfono: $telefono', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                Text('Dirección: $direccion', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
          ),
          onConfirmar: () {
            Navigator.of(context).pop();
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool esEdicion = widget.id != null;

    return CustomBottomModal(
      icono: esEdicion ? Icons.edit_outlined : Icons.person_add_alt_1_outlined,
      titulo: esEdicion ? 'Editar Paciente' : 'Nuevo Paciente',
      subtitulo: esEdicion
          ? 'Modifica la información y estado del paciente.'
          : 'Registra los datos personales y de contacto del paciente.',
      textoConfirmar: esEdicion ? 'Actualizar Paciente' : 'Guardar',
      onConfirmar: _validarYConfirmar,
      contenido: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Nombre',
              hintText: 'Ejemplo: Juan',
              controller: _nombreController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Apellido',
              hintText: 'Ejemplo: Pérez',
              controller: _apellidoController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El apellido es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Teléfono',
              hintText: 'Ejemplo: 88991234',
              controller: _telefonoController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El teléfono es obligatorio';
                }
                final soloNumeros = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (soloNumeros.length != 8) {
                  return 'El teléfono debe tener 8 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Dirección',
              hintText: 'Ejemplo: Managua, Nicaragua',
              controller: _direccionController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La dirección es obligatoria';
                }
                return null;
              },
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Selecciona la fecha de nacimiento';
                }
                return null;
              },
            ),
            if (esEdicion) ...[
              const SizedBox(height: 12),
              const Text(
                'Estado',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
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
          ],
        ),
      ),
    );
  }
}