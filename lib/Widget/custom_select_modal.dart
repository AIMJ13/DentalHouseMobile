import 'package:flutter/material.dart';

class CustomSelectModal extends StatelessWidget {
  final String label;
  final String valorSeleccionado;
  final List<String> opciones;
  final ValueChanged<String> onSeleccionado;

  const CustomSelectModal({
    super.key,
    required this.label,
    required this.valorSeleccionado,
    required this.opciones,
    required this.onSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: valorSeleccionado,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
              items: [
                for (var op in opciones)
                  DropdownMenuItem(
                    value: op,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(op, style: const TextStyle(fontSize: 14)),
                        if (op == valorSeleccionado)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Seleccionado',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
              onChanged: (val) {
                if (val != null) {
                  onSeleccionado(val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
