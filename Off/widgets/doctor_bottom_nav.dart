import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';
import '../../routes.dart';

class DoctorBottomNav extends StatelessWidget {
  final int currentIndex;

  const DoctorBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, Routes.doctorHome);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, Routes.citas);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, Routes.pacientes);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textGrey,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Citas',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
      ],
    );
  }
}
