import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';
import 'custom_button.dart';


Future<void> showConfirmarDialog(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  required String textoConfirmar,
  Color colorConfirmar = AppColors.danger,
  VoidCallback? onConfirmar,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: colorConfirmar, size: 40),
              const SizedBox(height: 12),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancelar',
                      color: Colors.grey[200],
                      textColor: AppColors.textDark,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: textoConfirmar,
                      color: colorConfirmar,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirmar?.call();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}