import 'package:flutter/material.dart';

class DentalLogo extends StatelessWidget {
  const DentalLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: const Icon(
            Icons.health_and_safety_outlined,
            color: Colors.blue,
            size: 30,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'DentalHouse',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
