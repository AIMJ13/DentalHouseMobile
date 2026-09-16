import 'package:flutter/material.dart';
import 'custom_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String advertencia;
  final Widget contenido;
  final String textoConfirmar;
  final VoidCallback onConfirmar;
  final IconData icono;
  final Color? colorIcono;
  final Color? colorFondoIcono;
  final Color? colorAdvertencia;
  final Color? colorFondoAdvertencia;
  final Color? colorBotonConfirmar;

  const ConfirmDialog({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.advertencia,
    required this.contenido,
    this.textoConfirmar = 'Sí, Desactivar',
    required this.onConfirmar,
    this.icono = Icons.warning_amber_rounded,
    this.colorIcono,
    this.colorFondoIcono,
    this.colorAdvertencia,
    this.colorFondoAdvertencia,
    this.colorBotonConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
                        color: colorFondoIcono ?? Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icono,
                        color: colorIcono ?? Colors.red[600],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          subtitulo,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18, color: Colors.black54),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            contenido,
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorFondoAdvertencia ?? Colors.red[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: colorAdvertencia ?? Colors.red[400],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      advertencia,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorAdvertencia ?? Colors.red[800],
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: textoConfirmar,
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirmar();
                    },
                    color: colorBotonConfirmar ?? Colors.red[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
