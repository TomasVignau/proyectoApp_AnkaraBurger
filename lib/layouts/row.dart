import 'package:flutter/material.dart';

class RowExample extends StatelessWidget {
  const RowExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 86),
      child: SizedBox(
        //height: double.infinity,
        child: const Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Ejemplo 1"),
            Spacer(),
            Text("Ejemplo 1"), 
            Text("Ejemplo 1")
            ],
        ),
      ),
    );
  }
}
