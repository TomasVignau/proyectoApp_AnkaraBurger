import 'package:flutter/material.dart';

class TextfieldExample extends StatelessWidget {
  const TextfieldExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade100,
      child: ListView(
        children: [
          SizedBox(height: 80),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Introduce el nombre",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.perm_identity),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Introduce el mail",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 10,
              decoration: InputDecoration(
                hintText: "Introduce el teléfono",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Introduce la contraseña",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
