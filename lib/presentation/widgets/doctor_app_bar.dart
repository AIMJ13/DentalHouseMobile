import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_colors.dart';
import '../../routes.dart';
import '../providers/auth_provider.dart';
import 'dental_logo.dart';

class DoctorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DoctorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final doctorNombre = auth.userName.isNotEmpty ? auth.userName : 'Doctor';
    final doctorInicial = auth.avatarLetra;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: const DentalLogo(),
      actions: [
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
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.black54, size: 20),
          tooltip: 'Cerrar Sesión',
          onPressed: () async {
            await context.read<AuthProvider>().logout();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
