import 'package:flutter/material.dart';

class CitasScreen extends StatelessWidget {
  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Citas'),
      ),
    );
  }
}
