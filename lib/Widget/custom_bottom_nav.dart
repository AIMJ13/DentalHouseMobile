import 'package:flutter/material.dart';
import '../Data/dashboard_data.dart';
import '../routes.dart';
import 'menu_mas_modal.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  void _defaultOnTap(BuildContext context, int index) {
    if (index == currentIndex) {
      if (index == 4 || (perfilUsuarioActual['rol'] == 'Doctor' && index == 3)) {
        mostrarMenuMas(context);
      }
      return;
    }
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
        Navigator.pushReplacementNamed(context, Routes.pacientes);
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
        Navigator.pushReplacementNamed(context, Routes.recepcionCitas);
        return;
      }
      if (index == 1) {
        Navigator.pushReplacementNamed(context, Routes.recepcionPacientes);
        return;
      }
      if (index == 2) {
        Navigator.pushReplacementNamed(context, Routes.recepcionEspecialidades);
        return;
      }
      if (index == 3) {
        Navigator.pushReplacementNamed(context, Routes.recepcionDoctores);
        return;
      }
      if (index == 4) {
        Navigator.pushReplacementNamed(context, Routes.recepcionServicios);
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
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Especialidad'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Doctor'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
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
    final items = _obtenerItemsNavegacion(rol);
    final int safeIndex = (currentIndex >= 0 && currentIndex < items.length) ? currentIndex : 0;

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (index) {
          if (onTap != null) {
            onTap!(index);
          } else {
            _defaultOnTap(context, index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: items,
      ),
    );
  }
}
