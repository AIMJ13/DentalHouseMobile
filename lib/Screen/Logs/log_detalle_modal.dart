import 'package:flutter/material.dart';
import '../../Widget/custom_button.dart';

class LogDetalleModal extends StatelessWidget {
  final Map<String, dynamic> log;

  const LogDetalleModal({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    final bool esError = log['estado'] == 'Error';
    final Color colorEstado = esError ? Colors.red[700]! : Colors.teal[700]!;
    final Color fondoEstado = esError ? Colors.red[50]! : Colors.teal[50]!;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.history, color: Colors.blue[700], size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Detalle de Evento',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                log['id'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Información de auditoría registrada',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 18, color: Colors.black54),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildFilaDetalle('Fecha y Hora:', log['fecha'] as String),
                  const Divider(height: 16),
                  _buildFilaDetalle('Usuario:', log['usuario'] as String),
                  const Divider(height: 16),
                  _buildFilaDetalle('Módulo:', log['modulo'] as String),
                  const Divider(height: 16),
                  _buildFilaDetalle('Tipo de Acción:', log['tipo'] as String),
                  const Divider(height: 16),
                  _buildFilaDetalle('Dirección IP:', log['ip'] as String),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estado:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: fondoEstado,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          log['estado'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colorEstado,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Descripción del Evento',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: log['esAlerta'] == true ? Colors.red[50] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: log['esAlerta'] == true ? Colors.red[200]! : Colors.grey[200]!,
                ),
              ),
              child: Text(
                log['descripcion'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: log['esAlerta'] == true ? Colors.red[800] : Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Cerrar',
                onPressed: () => Navigator.pop(context),
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilaDetalle(String etiqueta, String valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
