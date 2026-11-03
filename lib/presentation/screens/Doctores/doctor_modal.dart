import 'package:flutter/material.dart';
import '../../../data/models/doctor_model.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_bottom_modal.dart';
import '../../widgets/custom_select_modal.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/estado_toggle.dart';

class DoctorModal extends StatefulWidget {
  final DoctorModel? doctor;
  final void Function(
    String nombre,
    String apellido,
    String telefono,
    int especialidadId,
    bool activo,
  )? onGuardar;

  const DoctorModal({
    super.key,
    this.doctor,
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
    'Odontología General',
    'Periodoncia',
  ];

  bool get _esEdicion => widget.doctor != null;

  int _obtenerIdEspecialidad(String nombre) {
    if (widget.doctor != null && widget.doctor!.specialtyIds.isNotEmpty) {
      if (widget.doctor!.specialtyDisplay == nombre) {
        return widget.doctor!.specialtyIds.first;
      }
    }
    switch (nombre) {
      case 'Ortodoncia':
        return 1;
      case 'Endodoncia':
        return 2;
      case 'Odontología General':
        return 3;
      case 'Periodoncia':
        return 4;
      default:
        return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.doctor?.firstName ?? '');
    _apellidoController = TextEditingController(text: widget.doctor?.lastName ?? '');
    _telefonoController = TextEditingController(text: widget.doctor?.phone ?? '');
    _especialidadSeleccionada = widget.doctor?.specialtyDisplay ?? 'Ortodoncia';
    if (!_especialidades.contains(_especialidadSeleccionada)) {
      _especialidades.add(_especialidadSeleccionada);
    }
    _esActivo = widget.doctor?.isActive ?? true;
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
      icono: !_esEdicion ? Icons.person_add_alt_1_outlined : Icons.edit_outlined,
      titulo: !_esEdicion ? 'Añadir Nuevo Doctor' : 'Editar Doctor',
      badgeTexto: widget.doctor?.code,
      subtitulo: !_esEdicion
          ? 'Ingresa los datos del nuevo especialista'
          : 'Modifica la información y estado del médico',
      textoConfirmar: !_esEdicion ? 'Guardar Doctor' : 'Guardar Cambios',
      onConfirmar: () {
        final nom = _nombreController.text.trim();
        final ape = _apellidoController.text.trim();
        if (nom.isEmpty) return;

        Navigator.pop(context);
        if (widget.onGuardar != null) {
          final specId = _obtenerIdEspecialidad(_especialidadSeleccionada);
          widget.onGuardar!(
            nom,
            ape,
            _telefonoController.text.trim(),
            specId,
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
              if (!_esEdicion) {
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
                          widget.doctor?.titleFullName ?? 'Doctor',
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
                          widget.doctor?.titleFullName ?? 'Doctor',
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
