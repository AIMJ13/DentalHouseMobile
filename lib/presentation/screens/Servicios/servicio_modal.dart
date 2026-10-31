import 'package:flutter/material.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_bottom_modal.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/estado_toggle.dart';

class ServicioModal extends StatefulWidget {
  final String? id;
  final String? nombre;
  final String? costo;
  final bool activo;

  final Future<void> Function(String nombre, String costo, bool activo)?
  onGuardar;

  const ServicioModal({
    super.key,
    this.id,
    this.nombre,
    this.costo,
    this.activo = true,
    this.onGuardar,
  });

  @override
  State<ServicioModal> createState() => _ServicioModalState();
}

class _ServicioModalState extends State<ServicioModal> {
  late final TextEditingController _nombreController;
  late final TextEditingController _costoController;

  late bool _esActivo;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(text: widget.nombre ?? '');

    _costoController = TextEditingController(
      text: (widget.costo ?? '').replaceAll('C\$', '').trim(),
    );

    _esActivo = widget.activo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  Future<void> _cambiarEstado(bool nuevoEstado) async {
    if (nuevoEstado == _esActivo) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          titulo: nuevoEstado ? 'Activar servicio' : 'Desactivar servicio',
          subtitulo: nuevoEstado
              ? 'Confirmación de activación'
              : 'Confirmación de desactivación',
          advertencia: nuevoEstado
              ? 'El servicio estará disponible para su utilización.'
              : 'El servicio dejará de estar disponible.',
          contenido: Text(
            nuevoEstado
                ? '¿Deseás activar este servicio?'
                : '¿Deseás desactivar este servicio?',
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

  Future<void> _guardarServicio() async {
    if (_guardando) return;

    final nombre = _nombreController.text.trim();
    var costo = _costoController.text.trim();

    if (nombre.isEmpty || costo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completá todos los campos.')),
      );
      return;
    }

    if (!costo.startsWith('C\$')) {
      costo = 'C\$ $costo';
    }

    setState(() {
      _guardando = true;
    });

    try {
      await widget.onGuardar?.call(nombre, costo, _esActivo);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo guardar el servicio. Verificá la conexión e intentá nuevamente.',
          ),
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
      icono: widget.id == null
          ? Icons.add_business_outlined
          : Icons.edit_outlined,
      titulo: widget.id == null ? 'Nuevo servicio' : 'Editar servicio',
      badgeTexto: widget.id == null ? 'Nuevo' : 'Edición',
      subtitulo: widget.id == null
          ? 'Registrá un nuevo servicio odontológico'
          : 'Modificá la información del servicio',
      contenido: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _nombreController,
            label: 'Nombre del servicio',
            hintText: 'Ingrese el nombre del servicio',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _costoController,
            label: 'Costo',
            hintText: 'Ingrese el costo del servicio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                widthFactor: 1,
                child: Text(
                  'C\$',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          EstadoToggle(valor: _esActivo, onChanged: _cambiarEstado),
        ],
      ),
      textoConfirmar: _guardando ? 'Guardando...' : 'Guardar',
      onConfirmar: _guardarServicio,
    );
  }
}
