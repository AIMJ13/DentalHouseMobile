import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/menu_mas_modal.dart';
import '../../Widget/user_badge.dart';
import '../../routes.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  void _onBottomNavTapped(BuildContext context, int index) {
    final String rol = perfilUsuarioActual['rol'] as String? ?? 'Administrador';

    if (rol == 'Doctor') {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, Routes.home);
        return;
      }
      if (index == 1) {
        Navigator.pushReplacementNamed(context, Routes.citas);
        return;
      }
      if (index == 2) {
        return;
      }
      if (index == 3) {
        mostrarMenuMas(context);
        return;
      }
      return;
    }

    if (rol == 'Recepcionista') {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, Routes.home);
        return;
      }
      if (index == 1) {
        Navigator.pushReplacementNamed(context, Routes.citas);
        return;
      }
      if (index == 2) {
        return;
      }
      if (index == 3) {
        Navigator.pushReplacementNamed(context, Routes.servicios);
        return;
      }
      if (index == 4) {
        mostrarMenuMas(context);
        return;
      }
      return;
    }

    if (index == 0) {
      Navigator.pushReplacementNamed(context, Routes.home);
      return;
    }
    if (index == 1) {
      Navigator.pushReplacementNamed(context, Routes.servicios);
      return;
    }
    if (index == 2) {
      Navigator.pushReplacementNamed(context, Routes.ventas);
      return;
    }
    if (index == 3) {
      Navigator.pushReplacementNamed(context, Routes.citas);
      return;
    }
    if (index == 4) {
      mostrarMenuMas(context);
      return;
    }
  }

  List<BottomNavigationBarItem> _obtenerItemsNavegacion(String rol) {
    if (rol == 'Doctor') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
      ];
    }
    if (rol == 'Recepcionista') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
      ];
    }
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
      BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
      BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Ventas'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
      BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final String rol = perfilUsuarioActual['rol'] as String? ?? 'Administrador';

    int navIndex = 4;
    if (rol == 'Doctor' || rol == 'Recepcionista') {
      navIndex = 2;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: const DentalLogo(),
        actions: const [
          UserBadge(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 50, color: Colors.orange),
            const SizedBox(height: 10),
            const Text(
              'En construcción Pacientes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Módulo asignado a otro compañero de equipo',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: navIndex,
          onTap: (index) => _onBottomNavTapped(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: _obtenerItemsNavegacion(rol),
        ),
      ),
    );
  }
}
