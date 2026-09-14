import 'package:flutter/material.dart';
import '../../Widget/dental_logo.dart';
import '../../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }
    if (index == 1) {
      Navigator.pushNamed(context, Routes.servicios);
      return;
    }
    if (index == 2) {
      Navigator.pushNamed(context, Routes.ventas);
      return;
    }
    if (index == 3) {
      Navigator.pushNamed(context, Routes.citas);
      return;
    }
    if (index == 4) {
      _mostrarMenuMas();
    }
  }

  void _mostrarMenuMas() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
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
                      onPressed: () => Navigator.pop(context),
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Routes.especialidades);
                  },
                ),
                _buildModalItem(
                  icon: Icons.logout,
                  iconColor: Colors.red[700]!,
                  iconBgColor: Colors.red[50]!,
                  title: 'Cerrar Sesión',
                  subtitle: 'Salir del sistema',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, Routes.login);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: const DentalLogo(),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue[700],
                  child: const Text(
                    'A',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Administrador',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Panel Principal',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Hoy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Bienvenido de nuevo, Administrador. Aquí puedes visualizar los indicadores clave.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Ventas'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
        ],
      ),
    );
  }
}
