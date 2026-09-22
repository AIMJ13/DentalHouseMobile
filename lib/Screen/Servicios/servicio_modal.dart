import 'package:flutter/material.dart';
import '../../Widget/custom_bottom_modal.dart';
import '../../Widget/custom_text_field.dart';
import '../../Widget/estado_toggle.dart';

class ServicioModal extends StatefulWidget {
  final String? id;
  final String? nombre;
  final String? costo;
  final bool activo;
  final void Function(String nombre, String costo, bool activo)? onGuardar;

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

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre ?? '');
    String costoInicial = widget.costo ?? '';
    costoInicial = costoInicial.replaceAll('C\$', '').trim();
    _costoController = TextEditingController(text: costoInicial);
    _esActivo = widget.activo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomModal(
      icono: widget.id == null ? Icons.add_circle_outline : Icons.edit_outlined,
      titulo: widget.id == null ? 'Añadir Servicio' : 'Editar Servicio',
      badgeTexto: widget.id ?? 'NUEVO',
      subtitulo: widget.id == null
          ? 'Ingresa los datos del nuevo servicio clínico.'
          : 'Modifica la información y estado del servicio clínico.',
      textoConfirmar: 'Guardar',
      onConfirmar: () {
        final nombre = _nombreController.text.trim();
        var costo = _costoController.text.trim();
        if (nombre.isEmpty || costo.isEmpty) return;
        if (!costo.startsWith('C\$')) {
          costo = 'C\$ $costo';
        }
        Navigator.pop(context);
        if (widget.onGuardar != null) {
          widget.onGuardar!(nombre, costo, _esActivo);
        }
      },
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Nombre del Servicio',
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
            hintText: 'Ej. Ortodoncia Correctiva',
            controller: _nombreController,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Costo del Servicio (Córdobas)',
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
            hintText: '0.00',
            controller: _costoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Text(
                'C\$',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
              ),
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
