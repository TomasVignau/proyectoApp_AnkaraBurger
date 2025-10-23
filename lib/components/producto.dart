/*import 'package:flutter/material.dart';
import 'package:proyecto_app/core/app_Colors.dart';
import 'package:proyecto_app/components/hamburguesaSeleccionada.dart';

class Producto extends StatelessWidget {
  final String nombreProducto;
  final String urlImagen;
  final String descripcionProducto;
  final Map<String, int> ingredientes;
  final double precio;

  final Function(HamburguesaSeleccionada nueva) onAgregar;

  const Producto({
    super.key,
    required this.nombreProducto,
    required this.urlImagen,
    required this.descripcionProducto,
    required this.ingredientes,
    required this.precio,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                urlImagen,
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
                    nombreProducto,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcionProducto,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    'Precio: \$${precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      final nuevaHamburguesa = HamburguesaSeleccionada(
                        nombre: nombreProducto,
                        imagen: urlImagen,
                        descripcion: descripcionProducto,
                        precio: precio,
                        ingredientes: Map<String, int>.from(ingredientes),
                      );

                      onAgregar(nuevaHamburguesa);
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/

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
  final Function(String nombreProducto, List<Map<String, int>> nuevasUnidades)?
  onIngredientesCambiados;

  final double precio;
  final String tipo;

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
    required this.tipo,
  });

  @override
  State<Producto> createState() => _ProductoState();
}

class _ProductoState extends State<Producto> {
  late int totalProducto;
  late List<Map<String, int>> listaDeIngredientesPorUnidad;

  @override
  void initState() {
    super.initState();

    // Arranca en 0 si se desea
    totalProducto = widget.cantidadInicial;

    // Inicializamos la lista de ingredientes vacía o con elementos según la cantidad inicial
    listaDeIngredientesPorUnidad = List.generate(
      totalProducto,
      (_) => Map<String, int>.from(widget.ingredientes),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientesResumen =
        listaDeIngredientesPorUnidad.isNotEmpty
            ? listaDeIngredientesPorUnidad[0].keys.join(', ')
            : '';

    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 8, left: 8, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 190, 32),
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
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
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
                    widget.ingredientes.isNotEmpty
                        ? 'Ingredientes: ${widget.ingredientes.keys.join(', ')}'
                        : widget.descripcionProducto,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  Text(
                    'Precio: \$${widget.precio}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
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
                        // Agregamos una nueva hamburguesa con ingredientes por defecto
                        listaDeIngredientesPorUnidad.add(
                          Map<String, int>.from(widget.ingredientes),
                        );
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
                      if (totalProducto > 0) {
                        setState(() {
                          totalProducto--;
                          listaDeIngredientesPorUnidad.removeLast();
                          widget.onCantidadCambiada(
                            widget.nombreProducto,
                            totalProducto,
                          );
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                ),

                // Botón editar ingredientes
                if (widget.ingredientes.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      /*onPressed: () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ImcEditarHamburguesaScreen(
                                  listaDeIngredientes:
                                      listaDeIngredientesPorUnidad,
                                  cantidad: totalProducto,
                                ),
                          ),
                        );

                        if (resultado != null &&
                            resultado is List<Map<String, int>>) {
                          setState(() {
                            listaDeIngredientesPorUnidad =
                                resultado
                                    .map((e) => Map<String, int>.from(e))
                                    .toList();
                          });

                          // Imprimimos todas las hamburguesas editadas en consola
                          for (int i = 0; i < resultado.length; i++) {
                            print(
                              "Hamburguesa #${i + 1}: ${resultado[i].toString()}",
                            );
                          }
                        }
                      },*/
                      onPressed: () async {
                        // Paso 1: asegurar cantidad de mapas
                        if (listaDeIngredientesPorUnidad.length <
                            totalProducto) {
                          final base = Map<String, int>.from(
                            listaDeIngredientesPorUnidad.first,
                          );
                          while (listaDeIngredientesPorUnidad.length <
                              totalProducto) {
                            listaDeIngredientesPorUnidad.add(
                              Map<String, int>.from(base),
                            );
                          }
                        }

                        // Paso 2: abrir pantalla de edición
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ImcEditarHamburguesaScreen(
                                  listaDeIngredientes:
                                      listaDeIngredientesPorUnidad,
                                  cantidad: totalProducto,
                                ),
                          ),
                        );

                        // Paso 3: actualizar si hay resultado
                        if (resultado != null &&
                            resultado is List<Map<String, int>>) {
                          setState(() {
                            listaDeIngredientesPorUnidad =
                                resultado
                                    .map((e) => Map<String, int>.from(e))
                                    .toList();
                          });

                          // Paso 4: llamar callback una sola vez con todas las unidades
                          widget.onIngredientesCambiados?.call(
                            widget.nombreProducto,
                            listaDeIngredientesPorUnidad,
                          );

                          // (opcional) Debug
                          for (int i = 0; i < resultado.length; i++) {
                            print("Hamburguesa #${i + 1}: ${resultado[i]}");
                          }
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
