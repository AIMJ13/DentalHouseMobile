import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/user_badge.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
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
