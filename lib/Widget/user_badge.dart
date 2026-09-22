import 'package:flutter/material.dart';
import '../Data/dashboard_data.dart';
import '../routes.dart';

class UserBadge extends StatelessWidget {
  const UserBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final rolActual = perfilUsuarioActual['rol'] as String? ?? 'Administrador';
    final letra = perfilUsuarioActual['avatarLetra'] as String? ?? rolActual.substring(0, 1);

    Color fondoColor = Colors.blue[50]!;
    Color avatarColor = Colors.blue[700]!;
    Color textoColor = Colors.blue[800]!;

    if (rolActual == 'Doctor') {
      fondoColor = Colors.teal[50]!;
      avatarColor = Colors.teal[700]!;
      textoColor = Colors.teal[800]!;
    } else if (rolActual == 'Recepcionista') {
      fondoColor = Colors.amber[50]!;
      avatarColor = Colors.amber[800]!;
      textoColor = Colors.amber[900]!;
    }

    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.perfil),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: fondoColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: avatarColor,
              child: Text(
                letra,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              rolActual,
              style: TextStyle(
                fontSize: 12,
                color: textoColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
