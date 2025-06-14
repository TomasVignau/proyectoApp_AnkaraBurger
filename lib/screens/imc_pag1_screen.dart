import 'package:flutter/material.dart';
import 'package:proyecto_app/components/producto.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/database/database_helper.dart';
import 'package:proyecto_app/screens/imc_pedido_screen.dart';

class ImcPag1Screen extends StatefulWidget {
  final String mesaSeleccionada;

  const ImcPag1Screen({super.key, required this.mesaSeleccionada});

  @override
  State<ImcPag1Screen> createState() => _ImcPag1ScreenState();
}

class _ImcPag1ScreenState extends State<ImcPag1Screen> {
  List<ListaDeProductos> listadoDeProductos = [];
  int totalCantidadSeleccionada = 0;

  @override
  void initState() {
    super.initState();
    cargarProductosDesdeBaseDeDatos();
  }

  // Método para cargar los productos desde la base de datos
  void cargarProductosDesdeBaseDeDatos() async {
    listadoDeProductos = await DataBaseHelper.instance.obtenerProductos();
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
                  builder:
                      (context) =>
                          ImcPedidoScreen(listaDeProductos: listadoDeProductos, mesaSeleccionada: widget.mesaSeleccionada),
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
            child:
                listadoDeProductos.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                      children:
                          listadoDeProductos.map((producto) {
                            return Producto(
                              nombreProducto: producto.nombreProducto,
                              urlImagen: producto.urlImagen,
                              descripcionProducto: producto.descripcionProducto,
                              onCantidadCambiada: actualizarCantidad,
                              cantidadInicial: producto.cantidadSeleccionada,
                              ingredientes: producto.ingredientes,
                              onIngredientesCambiados: actualizarIngredientes,
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

  // Método para actualizar la cantidad
  void actualizarCantidad(String nombreProducto, int cantidad) {
    setState(() {
      final producto = listadoDeProductos.firstWhere(
        (producto) => producto.nombreProducto == nombreProducto,
      );
      producto.cantidadSeleccionada = cantidad;

      // Actualizar el total general
      totalCantidadSeleccionada = listadoDeProductos.fold(
        0,
        (suma, prod) => suma + prod.cantidadSeleccionada,
      );
    });
  }

  // Método para actualizar los ingredientes
  void actualizarIngredientes(
    String nombreProducto,
    Map<String, int> nuevosIngredientes,
  ) {
    setState(() {
      final producto = listadoDeProductos.firstWhere(
        (producto) => producto.nombreProducto == nombreProducto,
      );
      producto.ingredientes = nuevosIngredientes;
    });
  }
}

/*import 'package:flutter/material.dart';
import 'package:proyecto_app/components/producto.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/screens/imc_pedido_screen.dart';

class ImcPag1Screen extends StatefulWidget {
  const ImcPag1Screen({super.key});

  @override
  State<ImcPag1Screen> createState() => _ImcPag1ScreenState();
}

class _ImcPag1ScreenState extends State<ImcPag1Screen> {
  late List<ListaDeProductos> listadoDeProductos;

  @override
  void initState() {
    super.initState();
    listadoDeProductos = [
      ListaDeProductos(
        nombreProducto: "ANKARA",
        urlImagen: "assets/images/hamburguesaAnkara.JPG",
        descripcionProducto:
            "Pan de patata, triple carne smash, cheddar, bacon, bañada en cheddar y bacon.",
      ),
      ListaDeProductos(
        nombreProducto: "FUERTE AL MEDIO",
        urlImagen: "assets/images/hamburguesaFuerteAlMedio.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, mozzarella, tomate, albahaca y mayonesa especial.",
      ),
      ListaDeProductos(
        nombreProducto: "LA RÚSTICA",
        urlImagen: "assets/images/hamburguesaLaRustica.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, cheddar, lechuga, tomate, huevo y salsa ankara.",
      ),
      ListaDeProductos(
        nombreProducto: "MANO A MANO",
        urlImagen: "assets/images/hamburguesaManoAMano.JPG",
        descripcionProducto:
            "Pan de patata, smash de pollo, cheddar, lechuga, tomate, salsa mostaza y miel.",
      ),
      ListaDeProductos(
        nombreProducto: "DOBLE AMARILLA",
        urlImagen: "assets/images/hamburguesaDobleAmarilla.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, cheddar y salsa ankara.",
      ),
      ListaDeProductos(
        nombreProducto: "DOMINGOL",
        urlImagen: "assets/images/hamburguesaDomingol.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, cheddar, trocitos bacon, cebolla caramelizada y salsa ankara cheddar.",
      ),
      ListaDeProductos(
        nombreProducto: "A DOS TOQUES",
        urlImagen: "assets/images/hamburguesaADosToques.JPG",
        descripcionProducto:
            "Pan de patata, carne veggie, queso cheddar, pepinillos, lechuga y tomate.",
      ),
      ListaDeProductos(
        nombreProducto: "1/4 ANKARA",
        urlImagen: "assets/images/hamburguesaUnCuartoAnkara.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, cheddar, bacon, cebolla y salsa ¼ de ankara.",
      ),
      ListaDeProductos(
        nombreProducto: "QATAR 22",
        urlImagen: "assets/images/hamburguesaQatar22.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, provolone, lechuga, tomate y mayo de morrón asado.",
      ),
      ListaDeProductos(
        nombreProducto: "LA SCALONETA",
        urlImagen: "assets/images/hamburguesaLaScaloneta.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, cheddar, bacon rebozado, salsa cheddar, bacon triturado y barbacoa.",
      ),
      ListaDeProductos(
        nombreProducto: "LA AZTECA",
        urlImagen: "assets/images/hamburguesaLaAzteca.JPG",
        descripcionProducto:
            "Pan de patata, doble carne smash, provolone, lechuga, tomate, nachos, y guacamole.",
      ),
      ListaDeProductos(
        nombreProducto: "COCA-COLA",
        urlImagen: "assets/images/bebidaCocaCola.JPG",
        descripcionProducto: "Bebida",
      ),
      ListaDeProductos(
        nombreProducto: "NESTEA",
        urlImagen: "assets/images/bebidaNestea.JPG",
        descripcionProducto: "Bebida",
      ),
      ListaDeProductos(
        nombreProducto: "FANTA",
        urlImagen: "assets/images/bebidaFanta.JPG",
        descripcionProducto: "Bebida",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDF837E66),
      appBar: estiloAppBar(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ImcPedidoScreen(listaDeProductos: listadoDeProductos),
            ),
          );
          print("BOTÓN CARRITO PRESIONADO");
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.shopping_cart_outlined),
      ),

      body: ListView(
        children:
            listadoDeProductos.map((producto) {
              return Producto(
                nombreProducto: producto.nombreProducto,
                urlImagen: producto.urlImagen,
                descripcionProducto: producto.descripcionProducto,
                onCantidadCambiada: actualizarCantidad,
                cantidadInicial: producto.cantidadSeleccionada,
              );
            }).toList(),
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
          child: Image.asset(
            'assets/images/LogoAnkara.png',
            height: 75, // Puedes ajustar el tamaño como necesites
          ),
        ),
      ],
    );
  }

  // Método para actualizar la cantidad
  void actualizarCantidad(String nombreProducto, int cantidad) {
    setState(() {
      // Buscar el producto en la lista y actualizar su cantidad
      final producto = listadoDeProductos.firstWhere(
        (producto) => producto.nombreProducto == nombreProducto,
      );
      producto.cantidadSeleccionada = cantidad;
    });
  }
}
*/
