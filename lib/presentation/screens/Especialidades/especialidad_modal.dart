import 'package:flutter/material.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_bottom_modal.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/estado_toggle.dart';

class EspecialidadModal extends StatefulWidget {
  final int? id;
  final String? nombre;
  final bool activo;
  final Future<void> Function(String nombre, bool activo)? onGuardar;

  const EspecialidadModal({
    super.key,
    this.id,
    this.nombre,
    this.activo = true,
    this.onGuardar,
  });

  @override
  State<EspecialidadModal> createState() => _EspecialidadModalState();
}

class _EspecialidadModalState extends State<EspecialidadModal> {
  late final TextEditingController _nombreController;
  late bool _esActivo;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre ?? '');
    _esActivo = widget.activo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _cambiarEstado(bool nuevoEstado) async {
    if (nuevoEstado == _esActivo) return;

    if (widget.id == null) {
      setState(() {
        _esActivo = nuevoEstado;
      });
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          titulo: nuevoEstado ? 'Activar especialidad' : 'Desactivar especialidad',
          subtitulo: nuevoEstado
              ? 'Confirmación de activación'
              : 'Confirmación de desactivación',
          advertencia: nuevoEstado
              ? 'La especialidad estará disponible en el catálogo.'
              : 'La especialidad dejará de estar disponible.',
          contenido: Text(
            nuevoEstado
                ? '¿Deseás activar esta especialidad?'
                : '¿Deseás desactivar esta especialidad?',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          textoConfirmar: nuevoEstado ? 'Activar' : 'Desactivar',
          icono: nuevoEstado
              ? Icons.check_circle_outline
              : Icons.warning_amber_rounded,
          colorIcono: nuevoEstado ? Colors.green : Colors.red,
          colorBotonConfirmar: nuevoEstado ? Colors.green : Colors.red,
          onConfirmar: () {
            if (!mounted) return;
            setState(() {
              _esActivo = nuevoEstado;
            });
          },
        );
      },
    );
  }

  Future<void> _guardarEspecialidad() async {
    if (_guardando) return;

    final nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completá el nombre de la especialidad.')),
      );
      return;
    }

    if (nombre.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre de la especialidad debe tener al menos 5 letras.'),
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      await widget.onGuardar?.call(nombre, _esActivo);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final mensaje = e is AppException
          ? e.message
          : 'No se pudo guardar la especialidad. Verificá la conexión e intentá nuevamente.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomModal(
      icono: widget.id == null ? Icons.add_circle_outline : Icons.edit_outlined,
      titulo: widget.id == null ? 'Añadir Especialidad' : 'Editar Especialidad',
      badgeTexto: widget.id == null ? 'Nuevo' : 'Edición',
      subtitulo: widget.id == null
          ? 'Registra una nueva especialidad médica en el sistema.'
          : 'Modifica la información y estado de la especialidad en el sistema.',
      textoConfirmar: _guardando ? 'Guardando...' : 'Guardar Especialidad',
      onConfirmar: _guardarEspecialidad,
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Nombre de la Especialidad',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              Text(
                '*Requerido (mín. 5 letras)',
                style: TextStyle(fontSize: 11, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 6),
          CustomTextField(
            hintText: 'Ej. Odontopediatría',
            controller: _nombreController,
          ),
          const SizedBox(height: 16),
          const Text(
            'Estado',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          EstadoToggle(
            valor: _esActivo,
            onChanged: _cambiarEstado,
          ),
        ],
      ),
    );
  }
}
