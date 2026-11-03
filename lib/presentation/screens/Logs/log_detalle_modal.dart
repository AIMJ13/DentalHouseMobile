import 'package:flutter/material.dart';
import '../../../data/models/log_model.dart';
import '../../widgets/custom_button.dart';

class LogDetalleModal extends StatelessWidget {
  final LogModel log;

  const LogDetalleModal({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    final bool esFallo = !log.isSuccess;
    final Color colorEstado = esFallo ? Colors.red : Colors.green;
    final Color fondoEstado = esFallo ? Colors.red[50]! : Colors.green[50]!;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.history, color: Colors.blue[700], size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalle de Auditoría',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          log.code,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20, color: Colors.black54),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildFila('Fecha y Hora:', log.formattedDate),
                    const Divider(height: 16),
                    _buildFila('Usuario:', log.userName),
                    if (log.userRole != null && log.userRole!.isNotEmpty) ...[
                      const Divider(height: 16),
                      _buildFila('Rol:', log.userRole!),
                    ],
                    const Divider(height: 16),
                    _buildFila('Módulo:', log.module),
                    const Divider(height: 16),
                    _buildFila('Acción:', log.action),
                    const Divider(height: 16),
                    _buildFila('Dirección IP:', log.ipAddress),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estado:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: fondoEstado,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            log.status,
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
              const SizedBox(height: 16),
              Text(
                'DESCRIPCIÓN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: esFallo ? Colors.red[50] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: esFallo ? Colors.red[200]! : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  log.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: esFallo ? Colors.red[800] : Colors.black87,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
      ),
    );
  }

  Widget _buildFila(String etiqueta, String valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
