import 'package:flutter/material.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/core/app_Colors.dart';

class ImcPedidoScreen extends StatefulWidget {
  final List<ListaDeProductos> listaDeProductos;

  const ImcPedidoScreen({super.key, required this.listaDeProductos});

  @override
  State<ImcPedidoScreen> createState() => _ImcPedidoScreenState();
}

class _ImcPedidoScreenState extends State<ImcPedidoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: estiloAppBar(),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                for (var element in widget.listaDeProductos)
                  if (element.cantidadSeleccionada > 0)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                element.nombreProducto,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${element.cantidadSeleccionada}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                element.ingredientes.entries.map((entry) {
                                  final nombre = entry.key;
                                  final cantidad = entry.value;

                                  Color color;
                                  TextDecoration decoracion =
                                      TextDecoration.none;

                                  if (cantidad == 0) {
                                    color = Colors.red;
                                    decoracion = TextDecoration.lineThrough;
                                  } else if (cantidad == 1) {
                                    color = Colors.grey;
                                  } else {
                                    color = Colors.green;
                                  }

                                  return Text(
                                    cantidad > 1
                                        ? "$nombre x$cantidad"
                                        : nombre,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: color,
                                      decoration: decoracion,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("CONFIRMAR PEDIDO");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirmar Pedido',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar estiloAppBar() {
    return AppBar(
      title: const Text("PEDIDO"),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Image.asset(
            'assets/images/LogoAnkara.png',
            height: 75, // Puedes ajustar el tamaño como necesites
          ),
        ),
      ],
    );
  }
}
