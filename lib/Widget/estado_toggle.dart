import 'package:flutter/material.dart';

class EstadoToggle extends StatelessWidget {
  final bool valor;
  final ValueChanged<bool> onChanged;

  const EstadoToggle({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: valor ? Colors.green[600] : Colors.red[600],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                valor ? 'Activo' : 'Inactivo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valor ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ],
          ),
          Switch(
            value: valor,
            activeThumbColor: Colors.blue[700],
            activeTrackColor: Colors.blue[200],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
