import 'package:flutter/material.dart';
import 'Screen/Citas/citas_screen.dart';
import 'Screen/Doctores/doctores_screen.dart';
import 'Screen/Especialidades/especialidades_screen.dart';
import 'Screen/Home/home_screen.dart';
import 'Screen/Login/login_screen.dart';
import 'Screen/Pacientes/pacientes_screen.dart';
import 'Screen/Servicios/servicios_screen.dart';
import 'Screen/Ventas/ventas_screen.dart';
import 'Screen/DoctorHome/doctor_home_screen.dart';

class Routes {
  Routes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String citas = '/citas';
  static const String doctores = '/doctores';
  static const String especialidades = '/especialidades';
  static const String pacientes = '/pacientes';
  static const String servicios = '/servicios';
  static const String ventas = '/ventas';
  static const String doctorHome = '/doctor-home';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    citas: (context) => const CitasScreen(),
    doctores: (context) => const DoctoresScreen(),
    especialidades: (context) => const EspecialidadesScreen(),
    pacientes: (context) => const PacientesScreen(),
    servicios: (context) => const ServiciosScreen(),
    ventas: (context) => const VentasScreen(),
    doctorHome: (context) => const DoctorHomeScreen(),
  };
}
