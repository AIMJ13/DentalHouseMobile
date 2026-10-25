import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'data/dashboard_data.dart';
import 'data/repositories/token_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/Citas/citas_screen.dart';
import 'presentation/screens/DoctorHome/doctor_home_screen.dart';
import 'presentation/screens/Home/home_screen.dart';
import 'presentation/screens/Login/login_screen.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}
  await setupServiceLocator();

  final savedToken = await sl<TokenRepository>().getToken();
  if (savedToken != null && savedToken.roles.isNotEmpty) {
    final rol = savedToken.roles.first;
    perfilUsuarioActual['id'] = savedToken.id;
    perfilUsuarioActual['nombre'] = savedToken.userName;
    perfilUsuarioActual['usuario'] = savedToken.userName;
    perfilUsuarioActual['rol'] = rol;
    perfilUsuarioActual['email'] = savedToken.email;
    perfilUsuarioActual['avatarLetra'] = savedToken.userName.isNotEmpty
        ? savedToken.userName.substring(0, 1).toUpperCase()
        : 'U';
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()..checkAuthStatus()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DentalHouse',
        theme: ThemeData(
          fontFamily: 'Outfit',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isLoading) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (!auth.isAuthenticated) {
              return const LoginScreen();
            }
            final rol = auth.currentRole;
            if (rol == 'Doctor') {
              return const DoctorHomeScreen();
            }
            if (rol == 'Recepcionista') {
              return const CitasScreen();
            }
            return const HomeScreen();
          },
        ),
        routes: Routes.routes,
      ),
    );
  }
}
