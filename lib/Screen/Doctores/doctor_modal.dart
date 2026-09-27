import 'package:flutter/material.dart';
import '../../Widget/confirm_dialog.dart';
import '../../Widget/custom_bottom_modal.dart';
import '../../Widget/custom_select_modal.dart';
import '../../Widget/custom_text_field.dart';
import '../../Widget/estado_toggle.dart';

class DoctorModal extends StatefulWidget {
  final String? id;
  final String? nombre;
  final String? especialidad;
  final String? telefono;
  final bool activo;
  final void Function(
    String nombre,
    String especialidad,
    String telefono,
    bool activo,
  )? onGuardar;

  const DoctorModal({
    super.key,
    this.id,
    this.nombre,
    this.especialidad,
    this.telefono,
    this.activo = true,
    this.onGuardar,
  });

  @override
  State<DoctorModal> createState() => _DoctorModalState();
}

class _DoctorModalState extends State<DoctorModal> {
  late final TextEditingController _nombreController;
  late final TextEditingController _apellidoController;
  late final TextEditingController _telefonoController;
  late String _especialidadSeleccionada;
  late bool _esActivo;
  bool _confirmadoDesactivar = false;
  bool _confirmadoActivar = false;

  final List<String> _especialidades = [
    'Ortodoncia',
    'Endodoncia',
    'Odontología',
    'Odontología General',
    'Periodoncia',
  ];

  @override
  void initState() {
    super.initState();
    String nombreCompleto = widget.nombre ?? '';
    if (nombreCompleto.startsWith('Dr. ')) {
      nombreCompleto = nombreCompleto.substring(4);
    } else if (nombreCompleto.startsWith('Dra. ')) {
      nombreCompleto = nombreCompleto.substring(5);
    }
    final partes = nombreCompleto.trim().split(' ');
    _nombreController = TextEditingController(
      text: partes.isNotEmpty ? partes.first : '',
    );
    _apellidoController = TextEditingController(
      text: partes.length > 1 ? partes.sublist(1).join(' ') : '',
    );
    _telefonoController = TextEditingController(text: widget.telefono ?? '');
    _especialidadSeleccionada = widget.especialidad ?? 'Ortodoncia';
    if (!_especialidades.contains(_especialidadSeleccionada)) {
      _especialidades.add(_especialidadSeleccionada);
    }
    _esActivo = widget.activo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomModal(
      icono: widget.id == null ? Icons.person_add_alt_1_outlined : Icons.edit_outlined,
      titulo: widget.id == null ? 'Añadir Nuevo Doctor' : 'Editar Doctor',
      badgeTexto: widget.id,
      subtitulo: widget.id == null
          ? 'Ingresa los datos del nuevo especialista'
          : 'Modifica la información y estado del médico',
      textoConfirmar: widget.id == null ? 'Guardar Doctor' : 'Guardar Cambios',
      onConfirmar: () {
        final nom = _nombreController.text.trim();
        final ape = _apellidoController.text.trim();
        if (nom.isEmpty) return;

        final nombreCompleto = ape.isNotEmpty ? 'Dr. $nom $ape' : 'Dr. $nom';
        Navigator.pop(context);
        if (widget.onGuardar != null) {
          widget.onGuardar!(
            nombreCompleto,
            _especialidadSeleccionada,
            _telefonoController.text.trim(),
            _esActivo,
          );
        }
      },
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Nombre',
                  hintText: 'Carlos',
                  controller: _nombreController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  label: 'Apellido',
                  hintText: 'Mendoza',
                  controller: _apellidoController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Teléfono',
            hintText: '+505 8888-9999',
            controller: _telefonoController,
            prefixIcon: Icon(Icons.phone_outlined, size: 18, color: Colors.grey[500]),
          ),
          const SizedBox(height: 12),
          CustomSelectModal(
            label: 'Especialidad',
            valorSeleccionado: _especialidadSeleccionada,
            opciones: _especialidades,
            onSeleccionado: (val) {
              setState(() {
                _especialidadSeleccionada = val;
              });
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'Estado',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          EstadoToggle(
            valor: _esActivo,
            onChanged: (val) {
              if (widget.id == null) {
                setState(() => _esActivo = val);
                return;
              }
              if (!val) {
                if (!_confirmadoDesactivar) {
                  showDialog(
                    context: context,
                    builder: (ctx) => ConfirmDialog(
                      titulo: '¿Desactivar Doctor?',
                      subtitulo: 'Confirmar cambio de estado',
                      icono: Icons.warning_amber_rounded,
                      colorIcono: Colors.red[600],
                      colorFondoIcono: Colors.red[50],
                      colorAdvertencia: Colors.red[800],
                      colorFondoAdvertencia: Colors.red[50],
                      colorBotonConfirmar: Colors.red[500],
                      textoConfirmar: 'Sí, Desactivar',
                      advertencia: 'El doctor pasará a estado Inactivo. No podrá ser asignado a nuevas citas o consultas.',
                      contenido: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          widget.nombre ?? 'Doctor',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      onConfirmar: () {
                        setState(() {
                          _esActivo = false;
                          _confirmadoDesactivar = true;
                        });
                      },
                    ),
                  );
                } else {
                  setState(() => _esActivo = false);
                }
              } else {
                if (!_confirmadoActivar) {
                  showDialog(
                    context: context,
                    builder: (ctx) => ConfirmDialog(
                      titulo: '¿Activar Doctor?',
                      subtitulo: 'Confirmar reactivación médica',
                      icono: Icons.check_circle_outline,
                      colorIcono: Colors.teal[700],
                      colorFondoIcono: Colors.teal[50],
                      colorAdvertencia: Colors.teal[800],
                      colorFondoAdvertencia: Colors.teal[50],
                      colorBotonConfirmar: Colors.teal[700],
                      textoConfirmar: 'Sí, Activar',
                      advertencia: 'El doctor pasará a estado Activo. Estará disponible para citas y consultas médicas.',
                      contenido: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          widget.nombre ?? 'Doctor',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      onConfirmar: () {
                        setState(() {
                          _esActivo = true;
                          _confirmadoActivar = true;
                        });
                      },
                    ),
                  );
                } else {
                  setState(() => _esActivo = true);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
