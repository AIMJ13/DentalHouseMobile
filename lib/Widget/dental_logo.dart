import 'package:flutter/material.dart';

class DentalLogo extends StatelessWidget {
  const DentalLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.health_and_safety_outlined,
            color: Colors.blue,
            size: 26,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'DentalHouse',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
