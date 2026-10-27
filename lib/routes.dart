import 'package:flutter/material.dart';
import 'presentation/screens/Citas/citas_screen.dart';
import 'presentation/screens/DoctorHome/doctor_home_screen.dart';
import 'presentation/screens/Doctores/doctores_screen.dart';
import 'presentation/screens/Especialidades/especialidades_screen.dart';
import 'presentation/screens/Home/home_screen.dart';
import 'presentation/screens/Login/login_screen.dart';
import 'presentation/screens/Logs/logs_screen.dart';
import 'presentation/screens/Pacientes/pacientes_screen.dart';
import 'presentation/screens/Perfil/perfil_screen.dart';
import 'presentation/screens/Servicios/servicios_screen.dart';
import 'presentation/screens/Ventas/ventas_screen.dart';

class Routes {
  Routes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String doctorHome = '/doctor-home';
  static const String citas = '/citas';
  static const String doctores = '/doctores';
  static const String especialidades = '/especialidades';
  static const String logs = '/logs';
  static const String pacientes = '/pacientes';
  static const String perfil = '/perfil';
  static const String servicios = '/servicios';
  static const String ventas = '/ventas';

  static const String doctorAgenda = citas;
  static const String doctorPacientes = pacientes;
  static const String recepcionCitas = citas;
  static const String recepcionPacientes = pacientes;
  static const String recepcionEspecialidades = especialidades;
  static const String recepcionDoctores = doctores;
  static const String recepcionServicios = servicios;

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    doctorHome: (context) => const DoctorHomeScreen(),
    citas: (context) => const CitasScreen(),
    doctores: (context) => const DoctoresScreen(),
    especialidades: (context) => const EspecialidadesScreen(),
    logs: (context) => const LogsScreen(),
    pacientes: (context) => const PacientesScreen(),
    perfil: (context) => const PerfilScreen(),
    servicios: (context) => const ServiciosScreen(),
    ventas: (context) => const VentasScreen(),
  };
}
