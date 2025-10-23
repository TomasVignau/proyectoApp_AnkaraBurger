/*import 'package:flutter/material.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/core/app_Colors.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class ImcPedidoScreen extends StatefulWidget {
  final List<ListaDeProductos> listaDeProductos;
  final String mesaSeleccionada;

  const ImcPedidoScreen({
    super.key,
    required this.listaDeProductos,
    required this.mesaSeleccionada,
  });

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
                  /*onPressed: () {
                    print("COFIRMAR PEDIDO");
                  },*/
                  onPressed: () async {
                    print("COFIRMAR PEDIDO");
                    const String printerIp =
                        '192.168.0.123'; // IP de tu impresora
                    const int port =
                        9100; // Puerto por defecto para impresión ESC/POS

                    final profile = await CapabilityProfile.load();
                    final printer = NetworkPrinter(PaperSize.mm80, profile);

                    final PosPrintResult res = await printer.connect(
                      printerIp,
                      port: port,
                    );

                    if (res == PosPrintResult.success) {
                      printer.setStyles(
                        PosStyles(align: PosAlign.center, bold: true),
                      );
                      printer.text('*** Pedido Ankara ***');
                      printer.feed(1);

                      printer.text('Número de mesa: ${widget.mesaSeleccionada}');

                      for (var element in widget.listaDeProductos) {
                        if (element.cantidadSeleccionada > 0) {
                          printer.setStyles(
                            PosStyles(align: PosAlign.left, bold: true),
                          );
                          printer.text(
                            '${element.nombreProducto} x${element.cantidadSeleccionada}',
                          );

                          for (var entry in element.ingredientes.entries) {
                            final nombre = entry.key;
                            final cantidad = entry.value;

                            if (cantidad == 0) {
                              printer.setStyles(PosStyles(reverse: true));
                              printer.text('- $nombre REMOVIDO');
                            } else if (cantidad > 1) {
                              printer.setStyles(PosStyles());
                              printer.text('+ $nombre x$cantidad');
                            } else {
                              printer.setStyles(PosStyles());
                              printer.text('+ $nombre');
                            }
                          }

                          printer.feed(1);
                        }
                      }

                      printer.feed(1);
                      printer.cut();
                      printer.disconnect();
                    } else {
                      print('Error al conectar con la impresora: $res');

                      // Mostrar diálogo de error en pantalla
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error de impresión'),
                            content: Text(
                              'No se pudo conectar con la impresora. Código: $res',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Cierra el diálogo
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
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
}*/

// -------- PARA IMPRIMIR POR PDF --------

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/components/mesa.dart';
import 'package:proyecto_app/core/app_Colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:proyecto_app/databaseHelpers/mesa_helper.dart';
import 'package:proyecto_app/databaseHelpers/pedido_helper.dart';
import 'package:proyecto_app/screens/imc_home_screen.dart';

class ImcPedidoScreen extends StatefulWidget {
  final List<ListaDeProductos> listaDeProductos;
  final Mesa mesaSeleccionada;

  const ImcPedidoScreen({
    super.key,
    required this.listaDeProductos,
    required this.mesaSeleccionada,
  });

  @override
  State<ImcPedidoScreen> createState() => _ImcPedidoScreenState();
}

class _ImcPedidoScreenState extends State<ImcPedidoScreen> {
  @override
  Widget build(BuildContext context) {
    // Calculamos el total del pedido
    double totalPedido = widget.listaDeProductos.fold(0.0, (sum, product) {
      return sum + (product.cantidadSeleccionada * product.precioUnitario);
    });

    // Agrupar productos iguales según nombre e ingredientes
    final Map<String, ListaDeProductos> mapaAgrupado = {};

    for (var producto in widget.listaDeProductos.where(
      (p) => p.cantidadSeleccionada > 0,
    )) {
      // Creamos una clave única según el nombre y los ingredientes (ordenados)
      final clave =
          '${producto.nombreProducto}-${_claveIngredientes(producto.ingredientes)}';

      if (mapaAgrupado.containsKey(clave)) {
        mapaAgrupado[clave]!.cantidadSeleccionada +=
            producto.cantidadSeleccionada;
      } else {
        mapaAgrupado[clave] = ListaDeProductos(
          idProducto: producto.idProducto,
          nombreProducto: producto.nombreProducto,
          descripcionProducto: producto.descripcionProducto,
          tipo: producto.tipo,
          precioUnitario: producto.precioUnitario,
          urlImagen: producto.urlImagen,
          ingredientes: Map<String, int>.from(producto.ingredientes),
          cantidadSeleccionada: producto.cantidadSeleccionada,
        );
      }
    }

    final productosMostrables = mapaAgrupado.values.toList();

    // Mostrar ingredientes de cada producto con cantidad > 0
    for (var producto in widget.listaDeProductos.where(
      (p) => p.cantidadSeleccionada > 0,
    )) {
      print(
        'Producto: ${producto.nombreProducto} x${producto.cantidadSeleccionada}',
      );

      for (int i = 0; i < producto.ingredientesPorUnidad.length; i++) {
        print('  Unidad #${i + 1}: ${producto.ingredientesPorUnidad[i]}');
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: estiloAppBar(),
      body: Column(
        // Usamos Column para poder poner el resumen y el botón al final
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
          Expanded(
            // Expanded para que el ListView ocupe el espacio restante
            child:
                productosMostrables.isEmpty
                    ? const Center(
                      child: Text(
                        'No hay productos seleccionados para esta mesa.',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    )
                    : ListView.builder(
                      itemCount: productosMostrables.length,
                      itemBuilder: (context, index) {
                        final element = productosMostrables[index];
                        return Card(
                          // Usamos Card para el diseño prolijo
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          elevation: 4, // Sutil sombra
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sección de la Imagen (si tienes una URL de imagen en ListaDeProductos)
                                if (element
                                    .urlImagen
                                    .isNotEmpty) // Asumiendo que ListaDeProductos tiene urlImagen
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      // Usamos Image.network si la URL es remota
                                      element.urlImagen,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.broken_image,
                                                size: 70,
                                                color: Colors.grey,
                                              ),
                                    ),
                                  )
                                else
                                  Container(
                                    // Placeholder si no hay imagen
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Icon(
                                      Icons.fastfood,
                                      size: 35,
                                      color: Colors.grey,
                                    ),
                                  ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            "x${element.cantidadSeleccionada}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Precio Unitario: €${element.precioUnitario.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Subtotal: €${(element.precioUnitario * element.cantidadSeleccionada).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      ),
                                      // Ingredientes del producto
                                      if (element.ingredientes.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Wrap(
                                            spacing: 8,
                                            runSpacing: 4,
                                            children:
                                                element.ingredientes.entries.map((
                                                  entry,
                                                ) {
                                                  final nombre = entry.key;
                                                  final cantidad = entry.value;

                                                  Color color;
                                                  TextDecoration decoracion =
                                                      TextDecoration.none;

                                                  if (cantidad == 0) {
                                                    color = Colors.red;
                                                    decoracion =
                                                        TextDecoration
                                                            .lineThrough;
                                                  } else if (cantidad == 1) {
                                                    color = Colors.grey[600]!;
                                                  } else {
                                                    color =
                                                        Colors
                                                            .blue[700]!; // Color para ingredientes extra
                                                  }

                                                  return Text(
                                                    cantidad > 1
                                                        ? "$nombre x$cantidad"
                                                        : (cantidad == 0
                                                            ? nombre
                                                            : nombre), // Muestra "SIN" si cantidad es 0
                                                    style: TextStyle(
                                                      fontSize: 14,
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
                      },
                    ),
          ),
          // Sección de Resumen del Pedido y Botón de Confirmar (abajo fijo)
          if (productosMostrables.isNotEmpty) // Solo mostrar si hay productos
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, -2), // Sombra en la parte superior
                  ),
                ],
              ),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total del Pedido:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '€${totalPedido.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      imprimirConImpresoraComun(); // Tu lógica de impresión
                      final productosAActualizar =
                          widget.listaDeProductos
                              .where((p) => p.cantidadSeleccionada > 0)
                              .toList();
                      for (var p in productosAActualizar) {
                        print(
                          'Producto: ${p.nombreProducto}, id_Producto: ${p.idProducto}, cantidad: ${p.cantidadSeleccionada}',
                        );
                      }
                      PedidoHelper.actualizarPedido(
                        productosAActualizar,
                        widget.mesaSeleccionada,
                      );
                      MesaHelper.cambiarEstadoMesa(
                        widget.mesaSeleccionada.id,
                        1,
                      );
                      // Opcional: Navegar de vuelta o mostrar un mensaje de éxito
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImcHomeScreen(),
                        ),
                      );
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
          child: Image.asset('assets/images/LogoAnkara.png', height: 75),
        ),
      ],
    );
  }

  String _claveIngredientes(Map<String, int> ingredientes) {
    final entradasOrdenadas =
        ingredientes.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return entradasOrdenadas.map((e) => '${e.key}:${e.value}').join(',');
  }

  void imprimirConImpresoraComun() async {
    final pdf = pw.Document();
    double total = 0;

    // Agrupamos productos por nombre y por ingredientes
    final Map<String, Map<Map<String, int>, int>> productosAgrupados = {};

    for (var p in widget.listaDeProductos.where(
      (p) => p.cantidadSeleccionada > 0,
    )) {
      final key = p.nombreProducto;

      // Busca si ya hay un grupo con los mismos ingredientes
      bool encontrado = false;
      if (productosAgrupados.containsKey(key)) {
        productosAgrupados[key]!.forEach((ingred, cant) {
          if (mapEquals(ingred, p.ingredientes)) {
            productosAgrupados[key]![ingred] = cant + p.cantidadSeleccionada;
            encontrado = true;
          }
        });
      }

      if (!encontrado) {
        productosAgrupados.putIfAbsent(key, () => {});
        productosAgrupados[key]![p.ingredientes] = p.cantidadSeleccionada;
      }
    }

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Título
              pw.Center(
                child: pw.Text(
                  '*** Pedido Ankara ***',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // Número de mesa
              pw.Text('Número de mesa: ${widget.mesaSeleccionada.id}'),
              pw.Divider(),

              // Encabezado de la tabla
              pw.Table(
                border: null,
                columnWidths: {
                  0: const pw.FlexColumnWidth(4), // Producto
                  1: const pw.FlexColumnWidth(1), // Cantidad
                  2: const pw.FlexColumnWidth(2), // Precio
                  3: const pw.FlexColumnWidth(2), // Subtotal
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        'Producto',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Cant.',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Precio',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Subtotal',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),

                  // Filas de productos agrupados
                  ...productosAgrupados.entries.expand((entryProducto) {
                    final nombre = entryProducto.key;
                    return entryProducto.value.entries
                        .map((entryIngred) {
                          final ingredientes = entryIngred.key;
                          final cantidad = entryIngred.value;
                          final subtotal =
                              cantidad *
                              widget.listaDeProductos
                                  .firstWhere(
                                    (p) =>
                                        p.nombreProducto == nombre &&
                                        mapEquals(p.ingredientes, ingredientes),
                                  )
                                  .precioUnitario;
                          total += subtotal;

                          return [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  nombre,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text('$cantidad'),
                                pw.Text(
                                  '\$${(subtotal / cantidad).toStringAsFixed(2)}',
                                ),
                                pw.Text('\$${subtotal.toStringAsFixed(2)}'),
                              ],
                            ),
                            // Ingredientes
                            pw.TableRow(
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    for (var entry in ingredientes.entries)
                                      if (entry.value == 0)
                                        pw.Text(
                                          '   - SIN ${entry.key}',
                                          style: const pw.TextStyle(
                                            color: PdfColors.red,
                                          ),
                                        )
                                      else if (entry.value > 1)
                                        pw.Text(
                                          '   + ${entry.key} x${entry.value}',
                                        ),
                                  ],
                                ),
                                pw.SizedBox(),
                                pw.SizedBox(),
                                pw.SizedBox(),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.SizedBox(height: 8),
                                pw.SizedBox(),
                                pw.SizedBox(),
                                pw.SizedBox(),
                              ],
                            ),
                          ];
                        })
                        .expand((e) => e);
                  }),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Divider(),

              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'TOTAL: ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
