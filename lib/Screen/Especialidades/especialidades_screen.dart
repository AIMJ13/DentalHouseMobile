import 'package:flutter/material.dart';

class EspecialidadesScreen extends StatelessWidget {
  const EspecialidadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Especialidades'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Especialidades'),
      ),
    );
  }
}
