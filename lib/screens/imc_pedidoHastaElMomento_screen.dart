import 'package:flutter/material.dart';
import 'package:proyecto_app/components/listaDeProductos.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:proyecto_app/core/app_Colors.dart'; // Para tus colores personalizados

class Imc_pedidoHastaElMomento_screen extends StatelessWidget {
  final List<ListaDeProductos> listaDeProductos;
  final int
  mesaId; // Hacemos mesaId opcional, ya que puede que no siempre lo necesites aquí.

  const Imc_pedidoHastaElMomento_screen({
    Key? key,
    required this.listaDeProductos,
    required this.mesaId, // Ahora es opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculamos el total del pedido para mostrarlo al final
    double totalPedido = listaDeProductos.fold(0.0, (sum, product) {
      return sum + (product.cantidadSeleccionada * product.precioUnitario);
    });

    // Filtramos solo los productos con cantidad seleccionada > 0
    final productosMostrables =
        listaDeProductos.where((p) => p.cantidadSeleccionada > 0).toList();

    return Scaffold(
      backgroundColor:
          AppColors.background, // O el color que desees para esta pantalla
      appBar: AppBar(
        title: Text("Resumen Pedido Mesa: $mesaId"),
        backgroundColor: Colors.black, // Color del AppBar
        foregroundColor: Colors.white,
        centerTitle: true, // Centra el título
      ),
      body: Column(
        children: [
          Expanded(
            // Esto hace que el ListView ocupe el espacio restante
            child:
                productosMostrables.isEmpty
                    ? const Center(
                      child: Text(
                        'No hay productos en este pedido.',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    )
                    : ListView.builder(
                      itemCount: productosMostrables.length,
                      itemBuilder: (context, index) {
                        final producto = productosMostrables[index];
                        return _ProductoDetalleCard(
                          producto: producto,
                        ); // Usamos un widget interno para cada item
                      },
                    ),
          ),
          // Sección de Total del Pedido al final
          if (productosMostrables
              .isNotEmpty) // Solo mostrar el total si hay productos
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total del Pedido:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '€${totalPedido.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Widget privado para mostrar los detalles de un solo producto
class _ProductoDetalleCard extends StatelessWidget {
  final ListaDeProductos producto;

  const _ProductoDetalleCard({Key? key, required this.producto})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de la Imagen
            if (producto.urlImagen.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  producto.urlImagen,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.grey,
                      ), // Fallback
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
              ),
            const SizedBox(width: 12),

            // Detalles del Producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        producto.nombreProducto,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "x${producto.cantidadSeleccionada}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Precio Unitario: €${producto.precioUnitario.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  Text(
                    'Subtotal: €${(producto.precioUnitario * producto.cantidadSeleccionada).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  // Ingredientes
                  if (producto.ingredientes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        children:
                            producto.ingredientes.entries.map((entry) {
                              final nombre = entry.key;
                              final cantidad = entry.value;

                              Color color;
                              TextDecoration decoracion = TextDecoration.none;

                              if (cantidad == 0) {
                                color = Colors.red;
                                decoracion = TextDecoration.lineThrough;
                              } else if (cantidad == 1) {
                                color = Colors.grey[600]!;
                              } else {
                                color = Colors.blue[700]!;
                              }

                              return Text(
                                cantidad > 1
                                    ? "$nombre x$cantidad"
                                    : (cantidad == 0 ? nombre : nombre),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: color,
                                  decoration: decoracion,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
