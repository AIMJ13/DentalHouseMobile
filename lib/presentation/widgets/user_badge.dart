import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../providers/auth_provider.dart';

class UserBadge extends StatelessWidget {
  final bool habilitado;
  final VoidCallback? onTap;

  const UserBadge({
    super.key,
    this.habilitado = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rolActual = context.select<AuthProvider, String>((auth) => auth.currentRole);
    final letra = context.select<AuthProvider, String>((auth) => auth.avatarLetra);
    final bool estaEnPerfil = ModalRoute.of(context)?.settings.name == Routes.perfil;
    final bool puedeNavegar = habilitado && !estaEnPerfil;

    Color fondoColor = Colors.blue[50]!;
    Color avatarColor = Colors.blue[700]!;
    Color textoColor = Colors.blue[800]!;

    if (rolActual == 'Doctor') {
      fondoColor = Colors.teal[50]!;
      avatarColor = Colors.teal[700]!;
      textoColor = Colors.teal[800]!;
    } else if (rolActual == 'Recepcionista') {
      fondoColor = Colors.blue[50]!;
      avatarColor = Colors.blue[700]!;
      textoColor = Colors.blue[800]!;
    }

    VoidCallback? accionTap;
    if (onTap != null) {
      accionTap = onTap;
    } else if (puedeNavegar) {
      accionTap = () => Navigator.pushNamed(context, Routes.perfil);
    }

    return InkWell(
      onTap: accionTap,
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
              rolActual.isNotEmpty ? rolActual : 'Usuario',
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
