import 'package:flutter/material.dart';
import '../Theme/app_colors.dart';
import 'dental_logo.dart';


class DoctorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String doctorInicial;
  final String doctorNombre;

  const DoctorAppBar({
    super.key,
    this.doctorInicial = 'M',
    this.doctorNombre = 'Dr. Morales',
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: const DentalLogo(),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textDark),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    doctorInicial,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  doctorNombre,
                  style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}