import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_text_field.dart';
import '../../Widget/dental_logo.dart';
import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final inputUsuario = _usuarioController.text.trim().toLowerCase();
    final inputPassword = _passwordController.text.trim();

    Map<String, dynamic>? usuarioValido;
    for (var u in listaUsuarios) {
      final usr = (u['usuario'] as String).toLowerCase();
      final email = (u['email'] as String).toLowerCase();
      if (usr == inputUsuario || email == inputUsuario) {
        usuarioValido = u;
        break;
      }
    }

    if (usuarioValido == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario o correo no registrado en el sistema'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final passwordGuardada = usuarioValido['password'] as String? ?? '123456';
    if (passwordGuardada != inputPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña incorrecta'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final bool estaActivo = usuarioValido['activo'] as bool? ?? false;
    if (!estaActivo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta cuenta está inactiva. Contacta al administrador.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    perfilUsuarioActual['id'] = usuarioValido['id'];
    perfilUsuarioActual['nombre'] = usuarioValido['nombre'];
    perfilUsuarioActual['usuario'] = usuarioValido['usuario'];
    perfilUsuarioActual['rol'] = usuarioValido['rol'];
    perfilUsuarioActual['email'] = usuarioValido['email'];
    perfilUsuarioActual['telefono'] = usuarioValido['telefono'];
    perfilUsuarioActual['avatarLetra'] = (usuarioValido['nombre'] as String).substring(0, 1);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('rol', usuarioValido['rol'] as String);
    await prefs.setString('usuario', usuarioValido['usuario'] as String);

    final String rol = (usuarioValido['rol'] as String?) ?? 'Administrador';
    if (!mounted) return;
    if (rol == 'Doctor') {
      Navigator.pushNamedAndRemoveUntil(context, Routes.doctorHome, (route) => false);
    } else if (rol == 'Recepcionista') {
      Navigator.pushNamedAndRemoveUntil(context, Routes.citas, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 28.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const DentalLogo(),
                      const SizedBox(height: 20),
                      const Text(
                        'Inicio de Sesión',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa tus credenciales para acceder al sistema.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: 'Usuario',
                        hintText: 'admin, freyes o mizael.recepcion',
                        controller: _usuarioController,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Contraseña',
                        hintText: '••••••••',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'Mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Iniciar Sesión',
                        onPressed: _iniciarSesion,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
