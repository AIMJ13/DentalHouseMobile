import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Data/dashboard_data.dart';
import 'Screen/DoctorHome/doctor_home_screen.dart';
import 'Screen/Home/home_screen.dart';
import 'Screen/Login/login_screen.dart';
import 'Screen/RecepcionCitas/recepcion_citas_screen.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String rol = prefs.getString('rol') ?? 'Administrador';
  final String usuario = prefs.getString('usuario') ?? '';

  if (isLoggedIn) {
    perfilUsuarioActual['rol'] = rol;
    for (var u in listaUsuarios) {
      if ((u['usuario'] as String).toLowerCase() == usuario.toLowerCase() ||
          (u['rol'] as String).toLowerCase() == rol.toLowerCase()) {
        perfilUsuarioActual['id'] = u['id'];
        perfilUsuarioActual['nombre'] = u['nombre'];
        perfilUsuarioActual['usuario'] = u['usuario'];
        perfilUsuarioActual['rol'] = u['rol'];
        perfilUsuarioActual['email'] = u['email'];
        perfilUsuarioActual['telefono'] = u['telefono'];
        perfilUsuarioActual['avatarLetra'] = (u['nombre'] as String).substring(0, 1);
        break;
      }
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, rol: rol));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String rol;

  const MyApp({
    super.key,
    this.isLoggedIn = false,
    this.rol = 'Administrador',
  });

  Widget _determinarPantallaInicial() {
    if (!isLoggedIn) return const LoginScreen();
    if (rol == 'Doctor') return const DoctorHomeScreen();
    if (rol == 'Recepcionista') return const RecepcionCitasScreen();
    return const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DentalHouse',
      theme: ThemeData(
        fontFamily: 'Outfit',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: _determinarPantallaInicial(),
      routes: Routes.routes,
    );
  }
}