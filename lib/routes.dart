import 'package:flutter/material.dart';
import 'Screen/Citas/citas_screen.dart';
import 'Screen/Doctores/doctores_screen.dart';
import 'Screen/Especialidades/especialidades_screen.dart';
import 'Screen/Home/home_screen.dart';
import 'Screen/Login/login_screen.dart';
import 'Screen/Logs/logs_screen.dart';
import 'Screen/Pacientes/pacientes_screen.dart';
import 'Screen/Perfil/perfil_screen.dart';
import 'Screen/Servicios/servicios_screen.dart';
import 'Screen/Ventas/ventas_screen.dart';
import 'Screen/DoctorHome/doctor_home_screen.dart';
import 'Screen/DoctorAgenda/agenda_citas_screen.dart';
import 'Screen/DoctorPacientes/gestion_pacientes_screen.dart';
import 'Screen/RecepcionCitas/recepcion_citas_screen.dart';

class Routes {
  Routes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String citas = '/citas';
  static const String doctores = '/doctores';
  static const String especialidades = '/especialidades';
  static const String logs = '/logs';
  static const String pacientes = '/pacientes';
  static const String perfil = '/perfil';
  static const String servicios = '/servicios';
  static const String ventas = '/ventas';
  static const String doctorHome = '/doctor-home';
  static const String doctorAgenda = '/doctor-agenda';
  static const String doctorPacientes = '/doctor-pacientes';
  static const String recepcionCitas = '/recepcion-citas';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    citas: (context) => const CitasScreen(),
    doctores: (context) => const DoctoresScreen(),
    especialidades: (context) => const EspecialidadesScreen(),
    logs: (context) => const LogsScreen(),
    pacientes: (context) => const PacientesScreen(),
    perfil: (context) => const PerfilScreen(),
    servicios: (context) => const ServiciosScreen(),
    ventas: (context) => const VentasScreen(),
    doctorHome: (context) => const DoctorHomeScreen(),
    doctorAgenda: (context) => const AgendaCitasScreen(), 
    doctorPacientes: (context) => const GestionPacientesScreen(),
    recepcionCitas: (context) => const RecepcionCitasScreen(),


  };
}
