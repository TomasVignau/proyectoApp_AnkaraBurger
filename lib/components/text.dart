import 'package:flutter/material.dart';

class textExample extends StatelessWidget {
  const textExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Spacer(),
        Text("Texto Básico"),
        Text("Texto con estilo", style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),),
        Spacer(),
      ],
    );
  }
}