import 'package:flutter/material.dart';

class ImcEditarHamburguesaScreen extends StatefulWidget {
  final List<Map<String, int>> listaDeIngredientes; // <- cambiamos a lista
  final int cantidad; // cantidad de hamburguesas a editar

  const ImcEditarHamburguesaScreen({
    super.key,
    required this.listaDeIngredientes,
    required this.cantidad,
  });

  @override
  State<ImcEditarHamburguesaScreen> createState() =>
      _ImcEditarHamburguesaScreenState();
}

class _ImcEditarHamburguesaScreenState
    extends State<ImcEditarHamburguesaScreen> {
  late List<Map<String, int>> listasDeIngredientesEditables;

  @override
  void initState() {
    super.initState();
    // Creamos copias independientes de cada hamburguesa
    listasDeIngredientesEditables = widget.listaDeIngredientes
        .map((ingredientes) => Map<String, int>.from(ingredientes))
        .toList();
  }

  void incrementar(int index, String nombre) {
    setState(() {
      final mapa = listasDeIngredientesEditables[index];
      mapa[nombre] = (mapa[nombre] ?? 0) + 1;
    });
  }

  void decrementar(int index, String nombre) {
    setState(() {
      final mapa = listasDeIngredientesEditables[index];
      if ((mapa[nombre] ?? 0) > 0) {
        mapa[nombre] = mapa[nombre]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDF837E66),
      appBar: estiloAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listasDeIngredientesEditables.length,
        itemBuilder: (context, index) {
          final ingredientes = listasDeIngredientesEditables[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text("Hamburguesa #${index + 1}"),
              children: ingredientes.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => decrementar(index, entry.key),
                      ),
                      Text(
                        '${entry.value}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => incrementar(index, entry.key),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Devolvemos la lista completa de hamburguesas editadas
          Navigator.pop(context, listasDeIngredientesEditables);
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
