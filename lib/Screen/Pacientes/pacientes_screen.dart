import 'package:flutter/material.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Pacientes'),
      ),
    );
  }
}
