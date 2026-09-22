import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'Pantalla/Iniciar sesión/login_screen.dart';
import 'Pantalla/Citas/citas_screen.dart';
=======
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/Home/home_screen.dart';
import 'Screen/Login/login_screen.dart';
import 'routes.dart';
>>>>>>> origin/Alex

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, this.isLoggedIn = false});

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
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      routes: Routes.routes,
    );
  }
}
