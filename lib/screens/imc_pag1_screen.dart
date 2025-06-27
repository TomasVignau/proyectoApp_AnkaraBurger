// lib/screens/imc_pag1_screen.dart

import 'package:flutter/material.dart';
import 'package:proyecto_app/components/mesa.dart';
import 'package:proyecto_app/components/producto.dart'; // Tu widget Producto
import 'package:proyecto_app/components/listaDeProductos.dart'; // Tu modelo de datos ListaDeProductos
import 'package:proyecto_app/database/producto_helper.dart';
import 'package:proyecto_app/screens/imc_pedido_screen.dart';

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
      floatingActionButton: Stack(
        alignment: Alignment.topRight,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImcPedidoScreen(
                    listaDeProductos: listadoDeProductos, // Pasa la lista de modelos de datos
                    mesaSeleccionada: widget.mesaSeleccionada,
                  ),
                ),
              );
              print("BOTÓN CARRITO PRESIONADO");
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.shopping_cart_outlined),
          ),
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
      body: Column(
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
            child: listadoDeProductos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: listadoDeProductos.map((productoModel) { // Ahora 'productoModel' es una instancia de ListaDeProductos
                      return Producto( // Aquí usas tu Widget 'Producto'
                        nombreProducto: productoModel.nombreProducto,
                        urlImagen: productoModel.urlImagen,
                        descripcionProducto: productoModel.descripcionProducto,
                        onCantidadCambiada: actualizarCantidad,
                        cantidadInicial: productoModel.cantidadSeleccionada, // Le pasas la cantidad del modelo
                        ingredientes: productoModel.ingredientes,
                        onIngredientesCambiados: actualizarIngredientes,
                        precio: productoModel.precioUnitario,
                      );
                    }).toList(),
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
