import 'package:flutter/material.dart';
import 'package:proyecto_app/core/app_Colors.dart';
import 'package:proyecto_app/screens/imc_editarHamburguesa_screen.dart';

class Producto extends StatefulWidget {
  final String nombreProducto;
  final String urlImagen;
  final String descripcionProducto;
  final Function(String nombre, int cantidad) onCantidadCambiada;
  final int cantidadInicial;
  final Map<String, int> ingredientes;
  final Function(String nombreProducto, Map<String, int> nuevosIngredientes)?
  onIngredientesCambiados;
  final double precio;

  const Producto({
    super.key,
    required this.nombreProducto,
    required this.urlImagen,
    required this.descripcionProducto,
    required this.onCantidadCambiada,
    required this.cantidadInicial,
    required this.ingredientes,
    required this.onIngredientesCambiados,
    required this.precio,
  });

  @override
  State<Producto> createState() => _ProductoState();
}

class _ProductoState extends State<Producto> {
  late int totalProducto;
  late Map<String, int> ingredientesActuales;

  @override
  void initState() {
    super.initState();
    totalProducto = widget.cantidadInicial;
    ingredientesActuales = Map<String, int>.from(widget.ingredientes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 8, left: 8, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.urlImagen,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nombreProducto,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.descripcionProducto,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    'Precio: \$${widget.precio}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                // Botón +
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        totalProducto++;
                        widget.onCantidadCambiada(
                          widget.nombreProducto,
                          totalProducto,
                        );
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
                Text("$totalProducto", style: const TextStyle(fontSize: 16)),

                // Botón -
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (totalProducto > 0) {
                          totalProducto--;
                          widget.onCantidadCambiada(
                            widget.nombreProducto,
                            totalProducto,
                          );
                        }
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                ),

                // Botón editar ingredientes solo si hay ingredientes
                if (widget.ingredientes.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ImcEditarhamburguesaScreen(
                                  listaDeIngredientes: ingredientesActuales,
                                ),
                          ),
                        );

                        if (resultado != null &&
                            resultado is Map<String, int>) {
                          setState(() {
                            ingredientesActuales = Map<String, int>.from(
                              resultado,
                            );
                          });

                          if (widget.onIngredientesCambiados != null) {
                            widget.onIngredientesCambiados!(
                              widget.nombreProducto,
                              ingredientesActuales,
                            );
                          }

                          print(
                            "Ingredientes modificados: $ingredientesActuales",
                          );
                        }
                      },
                      icon: const Icon(Icons.edit, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
