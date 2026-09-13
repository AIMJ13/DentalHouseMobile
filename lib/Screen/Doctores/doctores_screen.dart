import 'package:flutter/material.dart';

class DoctoresScreen extends StatelessWidget {
  const DoctoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctores'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Doctores'),
      ),
    );
  }
}
