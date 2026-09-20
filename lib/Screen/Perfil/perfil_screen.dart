import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_text_field.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/user_badge.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _telefonoController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: perfilUsuarioActual['email'] as String);
    _telefonoController = TextEditingController(text: perfilUsuarioActual['telefono'] as String);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _guardarContacto() {
    final nuevoEmail = _emailController.text.trim();
    final nuevoTelefono = _telefonoController.text.trim();

    if (nuevoEmail.isEmpty || nuevoTelefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos de contacto'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      perfilUsuarioActual['email'] = nuevoEmail;
      perfilUsuarioActual['telefono'] = nuevoTelefono;
      for (var u in listaUsuarios) {
        if (u['id'] == perfilUsuarioActual['id']) {
          u['email'] = nuevoEmail;
          u['telefono'] = nuevoTelefono;
          break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos de contacto actualizados correctamente'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const DentalLogo(),
        actions: const [UserBadge()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVistaMiPerfil(),
          ],
        ),
      ),
    );
  }

  Widget _buildVistaMiPerfil() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blue[700],
                child: Text(
                  perfilUsuarioActual['avatarLetra'] as String? ?? 'U',
                  style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      perfilUsuarioActual['nombre'] as String? ?? '',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${perfilUsuarioActual['usuario']}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        perfilUsuarioActual['rol'] as String? ?? '',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildResumenCard('Citas Hoy', '${perfilUsuarioActual['citasHoy']}', Colors.amber[700]!)),
            const SizedBox(width: 10),
            Expanded(child: _buildResumenCard('Atenciones', '${perfilUsuarioActual['totalAtenciones']}', Colors.teal[700]!)),
            const SizedBox(width: 10),
            Expanded(child: _buildResumenCard('Estado', 'Activo', Colors.green[600]!)),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Actualizar Datos de Contacto', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
          child: Column(
            children: [
              CustomTextField(label: 'Correo Electrónico', hintText: 'admin@dentalhouse.com', controller: _emailController, prefixIcon: const Icon(Icons.email_outlined, size: 18, color: Colors.grey)),
              const SizedBox(height: 12),
              CustomTextField(label: 'Teléfono Personal', hintText: '+505 8888-1111', controller: _telefonoController, prefixIcon: const Icon(Icons.phone_outlined, size: 18, color: Colors.grey)),
              const SizedBox(height: 16),
              CustomButton(text: 'Guardar Contacto', onPressed: _guardarContacto, color: Colors.blue[700]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumenCard(String etiqueta, String valor, Color colorPunto) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 7, height: 7, decoration: BoxDecoration(color: colorPunto, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(etiqueta, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}
