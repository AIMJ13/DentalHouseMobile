import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes.dart';

void mostrarMenuMas(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (modalContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Accesos y Gestión',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Módulos adicionales de la clínica',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 18, color: Colors.black54),
                    ),
                    onPressed: () => Navigator.pop(modalContext),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildModalItem(
                icon: Icons.medical_services_outlined,
                iconColor: Colors.amber[800]!,
                iconBgColor: Colors.amber[50]!,
                title: 'Doctores',
                subtitle: 'Gestión médica y turnos',
                onTap: () {
                  Navigator.pop(modalContext);
                  Navigator.pushNamed(context, Routes.doctores);
                },
              ),
              _buildModalItem(
                icon: Icons.people_outline,
                iconColor: Colors.teal[700]!,
                iconBgColor: Colors.teal[50]!,
                title: 'Pacientes',
                subtitle: 'Directorio e historial clínico',
                onTap: () {
                  Navigator.pop(modalContext);
                  Navigator.pushNamed(context, Routes.pacientes);
                },
              ),
              _buildModalItem(
                icon: Icons.science_outlined,
                iconColor: Colors.blue[700]!,
                iconBgColor: Colors.blue[50]!,
                title: 'Especialidades',
                subtitle: 'Áreas clínicas y tratamientos',
                onTap: () {
                  Navigator.pop(modalContext);
                  Navigator.pushNamed(context, Routes.especialidades);
                },
              ),
              _buildModalItem(
                icon: Icons.logout,
                iconColor: Colors.red[700]!,
                iconBgColor: Colors.red[50]!,
                title: 'Cerrar Sesión',
                subtitle: 'Salir del sistema',
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (!context.mounted) return;
                  Navigator.pop(modalContext);
                  Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildModalItem({
  required IconData icon,
  required Color iconColor,
  required Color iconBgColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    ),
  );
}
