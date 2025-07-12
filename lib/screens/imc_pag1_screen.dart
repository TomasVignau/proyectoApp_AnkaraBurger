/*import 'package:flutter/material.dart';
import 'package:proyecto_app/components/producto.dart';
import 'package:proyecto_app/components/hamburguesaSeleccionada.dart';
import 'package:proyecto_app/screens/resumenDePedidoScreen.dart';
import 'package:proyecto_app/components/mesa.dart';

class ImcPag1Screen extends StatefulWidget {
  final Mesa mesaSeleccionada;

  const ImcPag1Screen({super.key, required this.mesaSeleccionada});

  @override
  State<ImcPag1Screen> createState() => _ImcPag1ScreenState();
}

class _ImcPag1ScreenState extends State<ImcPag1Screen> {
  List<HamburguesaSeleccionada> hamburguesasSeleccionadas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDF837E66),
      appBar: estiloAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Text(
              'Mesa seleccionada: ${widget.mesaSeleccionada.id}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                Producto(
                  nombreProducto: "Clásica",
                  urlImagen: "assets/images/clasica.png",
                  descripcionProducto: "Hamburguesa con lechuga, tomate y carne.",
                  precio: 1500,
                  ingredientes: {
                    "Pan": 1,
                    "Carne": 1,
                    "Lechuga": 1,
                    "Tomate": 1,
                    "Queso": 1,
                  },
                  onAgregar: (hamburguesa) {
                    setState(() {
                      hamburguesasSeleccionadas.add(hamburguesa);
                    });
                  },
                ),
                Producto(
                  nombreProducto: "Doble Bacon",
                  urlImagen: "assets/images/bacon.png",
                  descripcionProducto: "Doble carne, bacon y cheddar.",
                  precio: 1900,
                  ingredientes: {
                    "Pan": 1,
                    "Carne": 2,
                    "Bacon": 2,
                    "Queso": 2,
                  },
                  onAgregar: (hamburguesa) {
                    setState(() {
                      hamburguesasSeleccionadas.add(hamburguesa);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        label: const Text("VER PEDIDO", style: TextStyle(color: Colors.amber)),
        icon: const Icon(Icons.shopping_cart, color: Colors.amber),
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResumenDePedidoScreen(hamburguesas: hamburguesasSeleccionadas),
            ),
          );

          if (resultado != null && resultado is List<HamburguesaSeleccionada>) {
            setState(() {
              hamburguesasSeleccionadas = resultado;
            });
          }
        },
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
}*/


import 'package:flutter/material.dart';
import 'package:proyecto_app/components/mesa.dart';
import 'package:proyecto_app/components/producto.dart'; // Tu widget Producto
import 'package:proyecto_app/components/listaDeProductos.dart'; // Tu modelo de datos ListaDeProductos
import 'package:proyecto_app/database/pedido_helper.dart';
import 'package:proyecto_app/database/producto_helper.dart';
import 'package:proyecto_app/screens/imc_pedido_screen.dart';
import 'package:proyecto_app/screens/imc_pedidoHastaElMomento_screen.dart';

class ImcPag1Screen extends StatefulWidget {
  final Mesa mesaSeleccionada;

  const ImcPag1Screen({super.key, required this.mesaSeleccionada});

  @override
  State<ImcPag1Screen> createState() => _ImcPag1ScreenState();
}

class _ImcPag1ScreenState extends State<ImcPag1Screen> {
  // Esta declaración ya es correcta
  List<ListaDeProductos> listadoDeProductos = [];
  int totalCantidadSeleccionada = 0;

  @override
  void initState() {
    super.initState();
    cargarProductosDesdeBaseDeDatos();
  }

  void cargarProductosDesdeBaseDeDatos() async {
    // Aquí es donde ocurría el error, ahora ProductoHelper devuelve el tipo correcto
    listadoDeProductos = await ProductoHelper.obtenerProductos();
    // Después de cargar, actualiza el total si es necesario (si los productos iniciales tienen cantidad > 0)
    totalCantidadSeleccionada = listadoDeProductos.fold(
      0,
      (sum, prod) => sum + prod.cantidadSeleccionada,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDF837E66),
      appBar: estiloAppBar(),
      // Eliminamos floatingActionButton de aquí porque lo manejaremos dentro del body
      body: Stack(
        children: [
          // Contenido principal de tu pantalla
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black87,
                child: Text(
                  'Mesa seleccionada: ${widget.mesaSeleccionada}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child:
                    listadoDeProductos.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                          children:
                              listadoDeProductos.map((productoModel) {
                                return Producto(
                                  nombreProducto: productoModel.nombreProducto,
                                  urlImagen: productoModel.urlImagen,
                                  descripcionProducto:
                                      productoModel.descripcionProducto,
                                  onCantidadCambiada: actualizarCantidad,
                                  cantidadInicial:
                                      productoModel.cantidadSeleccionada,
                                  ingredientes: productoModel.ingredientes,
                                  onIngredientesCambiados:
                                      actualizarIngredientes,
                                  precio: productoModel.precioUnitario,
                                );
                              }).toList(),
                        ),
              ),
            ],
          ),

          // Botón "VER PEDIDO" en la esquina inferior izquierda
          Positioned(
            left: 16, // Margen desde la izquierda
            bottom: 16, // Margen desde la parte inferior
            child: FloatingActionButton(
              heroTag: "verPedidoBtn", // Único heroTag
              onPressed: () async {
                final productos = await PedidoHelper.verPedido(widget.mesaSeleccionada.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Imc_pedidoHastaElMomento_screen(
                          mesaId: widget.mesaSeleccionada.id,
                          listaDeProductos: productos,
                        ),
                  ),
                );
                print("BOTÓN VER PEDIDO PRESIONADO");
              },
              backgroundColor: Colors.black,
              child: const Text(
                "VER PEDIDO",
                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.amber),
              ),
            ),
          ),

          // Botón del carrito en la esquina inferior derecha
          Positioned(
            right: 16, // Margen desde la derecha
            bottom: 16, // Margen desde la parte inferior
            child: Stack(
              // Usamos un Stack aquí para el icono del carrito y el contador
              alignment: Alignment.topRight, // Alineamos el contador arriba a la derecha del FAB
              children: [
                FloatingActionButton(
                  heroTag: "carritoBtn", // Único heroTag
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ImcPedidoScreen(
                              listaDeProductos: listadoDeProductos,
                              mesaSeleccionada: widget.mesaSeleccionada,
                            ),
                      ),
                    );
                    print("BOTÓN CARRITO PRESIONADO");
                  },
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.shopping_cart_outlined, color: Colors.amber),
                ),
                // Contador de cantidad
                if (totalCantidadSeleccionada > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalCantidadSeleccionada',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  // Método para actualizar la cantidad (ahora opera sobre ListaDeProductos)
  void actualizarCantidad(String nombreProducto, int cantidad) {
    setState(() {
      final producto = listadoDeProductos.firstWhere(
        (p) => p.nombreProducto == nombreProducto,
      );
      producto.cantidadSeleccionada = cantidad;

      // Actualizar el total general
      totalCantidadSeleccionada = listadoDeProductos.fold(
        0,
        (suma, prod) => suma + prod.cantidadSeleccionada,
      );
    });
  }

  // Método para actualizar los ingredientes (ahora opera sobre ListaDeProductos)
  void actualizarIngredientes(
    String nombreProducto,
    Map<String, int> nuevosIngredientes,
  ) {
    setState(() {
      final producto = listadoDeProductos.firstWhere(
        (p) => p.nombreProducto == nombreProducto,
      );
      producto.ingredientes = nuevosIngredientes;
    });
  }
}
