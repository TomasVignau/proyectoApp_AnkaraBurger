import 'package:flutter/material.dart';

class ColumnExample extends StatelessWidget {
  const ColumnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(143, 230, 207, 4),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Hola soy Tomás"),
          Text("Hola soy Tomás"),
          Text("Hola soy Tomás"),
          Text("Hola soy Tomás"),
          Text("Hola soy Tomás"),
          Text("Hola soy Tomás"),
          Text("Hola soy Tomás"),
        ],
      ),
    );
  }
}
