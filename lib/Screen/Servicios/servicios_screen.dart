import 'package:flutter/material.dart';

class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Servicios'),
      ),
    );
  }
}
