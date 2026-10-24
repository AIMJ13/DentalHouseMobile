import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
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
            if (!auth.isAuthenticated) {
              return const LoginScreen();
            }
            final roles = auth.token?.roles ?? [];
            if (roles.contains('Doctor')) {
              return const DoctorHomeScreen();
            }
            if (roles.contains('Recepcionista')) {
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
