import 'package:flutter/material.dart';
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
import 'Screen/Citas/citas_screen.dart';
import 'Screen/RecepcionPacientes/recepcion_pacientes_screen.dart';
import 'Screen/RecepcionEspecialidades/recepcion_especialidades_screen.dart';
import 'Screen/RecepcionDoctores/recepcion_doctores_screen.dart';
import 'Screen/RecepcionServicios/recepcion_servicios_screen.dart';

class Routes {
  Routes._();

  // --- Rutas Generales y Administrador ---
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

  // --- Rutas Doctor (Katya) ---
  static const String doctorHome = '/doctor-home';
  static const String doctorAgenda = '/doctor-agenda';
  static const String doctorPacientes = '/doctor-pacientes';

  // --- Rutas Recepcionista (Arellys) ---
  static const String recepcionCitas = '/recepcion-citas';
  static const String recepcionPacientes = '/recepcion-pacientes';
  static const String recepcionEspecialidades = '/recepcion-especialidades';
  static const String recepcionDoctores = '/recepcion-doctores';
  static const String recepcionServicios = '/recepcion-servicios';

  static Map<String, WidgetBuilder> get routes => {
    // Administrador / Generales
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

    // Doctor (Katya)
    doctorHome: (context) => const DoctorHomeScreen(),
    doctorAgenda: (context) => const AgendaCitasScreen(),
    doctorPacientes: (context) => const GestionPacientesScreen(),

    // Recepcionista (Arellys)
    recepcionCitas: (context) => const RecepcionCitasScreen(),
    recepcionPacientes: (context) => const RecepcionPacientesScreen(),
    recepcionEspecialidades: (context) => const RecepcionEspecialidadesScreen(),
    recepcionDoctores: (context) => const RecepcionDoctoresScreen(),
    recepcionServicios: (context) => const RecepcionServiciosScreen(),
  };
}