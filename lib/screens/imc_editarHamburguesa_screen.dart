import 'package:flutter/material.dart';

class ImcEditarhamburguesaScreen extends StatefulWidget {
  final Map<String, int> listaDeIngredientes;

  const ImcEditarhamburguesaScreen({
    super.key,
    required this.listaDeIngredientes,
  });

  @override
  State<ImcEditarhamburguesaScreen> createState() =>
      _ImcEditarhamburguesaScreenState();
}

class _ImcEditarhamburguesaScreenState
    extends State<ImcEditarhamburguesaScreen> {
  late Map<String, int> ingredientesEditables;

  @override
  void initState() {
    super.initState();
    // Clonamos para editar sin modificar el original hasta confirmar
    ingredientesEditables = Map.from(widget.listaDeIngredientes);
  }

  void incrementar(String nombre) {
    setState(() {
      ingredientesEditables[nombre] = (ingredientesEditables[nombre] ?? 0) + 1;
    });
  }

  void decrementar(String nombre) {
    setState(() {
      if ((ingredientesEditables[nombre] ?? 0) > 0) {
        ingredientesEditables[nombre] = ingredientesEditables[nombre]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDF837E66),
      appBar: estiloAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:
            ingredientesEditables.entries.map((entry) {
              return Card(
                child: ListTile(
                  title: Text(entry.key),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => decrementar(entry.key),
                      ),
                      Text(
                        '${entry.value}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => incrementar(entry.key),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Volver a la pantalla anterior pasando los cambios
          Navigator.pop(context, ingredientesEditables);
        },
        label: const Text("Guardar"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  AppBar estiloAppBar() {
    return AppBar(
      title: const Text("COMANDA"),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Image.asset('assets/images/LogoAnkara.png', height: 75),
        ),
      ],
    );
  }
}
