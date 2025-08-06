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

import 'package:flutter/material.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/components/mesa.dart';
import 'package:proyecto_app/core/app_Colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:proyecto_app/database/mesa_helper.dart';
import 'package:proyecto_app/database/pedido_helper.dart';
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

    // Filtramos solo los productos con cantidad seleccionada > 0 para mostrarlos
    final productosMostrables =
        widget.listaDeProductos.where((p) => p.cantidadSeleccionada > 0).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: estiloAppBar(),
      body: Column( // Usamos Column para poder poner el resumen y el botón al final
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
          Expanded( // Expanded para que el ListView ocupe el espacio restante
            child: productosMostrables.isEmpty
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
                      return Card( // Usamos Card para el diseño prolijo
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                              if (element.urlImagen.isNotEmpty) // Asumiendo que ListaDeProductos tiene urlImagen
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset( // Usamos Image.network si la URL es remota
                                    element.urlImagen,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 70, color: Colors.grey),
                                  ),
                                )
                              else
                                Container( // Placeholder si no hay imagen
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Icon(Icons.fastfood, size: 35, color: Colors.grey),
                                ),
                              const SizedBox(width: 12),

                              Expanded(
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
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: element.ingredientes.entries.map((entry) {
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
                                              color = Colors.blue[700]!; // Color para ingredientes extra
                                            }

                                            return Text(
                                              cantidad > 1
                                                  ? "$nombre x$cantidad"
                                                  : (cantidad == 0 ? nombre : nombre), // Muestra "SIN" si cantidad es 0
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
                      MesaHelper.cambiarEstadoMesa(widget.mesaSeleccionada.id, 1);
                      final productosAActualizar = widget.listaDeProductos.where((p) => p.cantidadSeleccionada > 0).toList();
                      PedidoHelper.actualizarPedido(productosAActualizar, widget.mesaSeleccionada);
                      // Opcional: Navegar de vuelta o mostrar un mensaje de éxito
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ImcHomeScreen(),
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
          child: Image.asset(
            'assets/images/LogoAnkara.png',
            height: 75,
          ),
        ),
      ],
    );
  }

  void imprimirConImpresoraComun() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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
              pw.Text('Número de mesa: ${widget.mesaSeleccionada.id}'),
              pw.SizedBox(height: 10),
              for (var element in widget.listaDeProductos)
                if (element.cantidadSeleccionada > 0) ...[
                  pw.Text(
                    '${element.nombreProducto} x${element.cantidadSeleccionada}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  for (var entry in element.ingredientes.entries)
                    // Mostrar ingredientes solo si la cantidad no es 1 (cantidad por defecto)
                    // o si es 0 (SIN) o >1 (extra)
                    if (entry.value == 0)
                      pw.Text(
                        '       - SIN ${entry.key}',
                        style: const pw.TextStyle(color: PdfColors.red),
                      )
                    else if (entry.value > 1)
                      pw.Text('     + ${entry.key} x${entry.value}'),
                    // else if (entry.value == 1) // Puedes optar por no mostrar los ingredientes "normales" para un ticket más limpio
                    //   pw.Text('     + ${entry.key}'),
                  pw.SizedBox(height: 10),
                ],
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

/*import 'package:flutter/material.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/components/mesa.dart';
import 'package:proyecto_app/core/app_Colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:proyecto_app/database/mesa_helper.dart';
import 'package:proyecto_app/database/pedido_helper.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: estiloAppBar(),
      body: ListView(
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
                              Spacer(),
                              Text(
                                "${element.cantidadSeleccionada}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "\n€${element.precioUnitario}",
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
                    Future<String> fechaDelPedido;
                    if (MesaHelper.verEstadoMesa(widget.mesaSeleccionada.id) == 0){
                      MesaHelper.cambiarEstadoMesa(widget.mesaSeleccionada.id, 1);
                    }
                    
                    fechaDelPedido = PedidoHelper.obtenerFechaYHoraDelPedido(widget.mesaSeleccionada.id);

                    imprimirConImpresoraComun(fechaDelPedido);

                    // Filtrá solo productos con cantidad > 0 antes de mandar a actualizar
                    final productosSeleccionados = widget.listaDeProductos.where((p) => p.cantidadSeleccionada > 0).toList();

                    PedidoHelper.actualizarPedido(
                      productosSeleccionados,
                      widget.mesaSeleccionada,
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
          child: Image.asset(
            'assets/images/LogoAnkara.png',
            height: 75, // Puedes ajustar el tamaño como necesites
          ),
        ),
      ],
    );
  }

  void imprimirConImpresoraComun(Future<String> fechaDelPedido) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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
              pw.Text('Número de mesa: ${widget.mesaSeleccionada}'),
              pw.Text('Fecha del pedido: $fechaDelPedido'),
              pw.SizedBox(height: 10),
              for (var element in widget.listaDeProductos)
                if (element.cantidadSeleccionada > 0) ...[
                  pw.Text(
                    '${element.nombreProducto} x${element.cantidadSeleccionada}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  for (var entry in element.ingredientes.entries)
                    if (entry.value == 0)
                      pw.Text(
                        '       - SIN ${entry.key}',
                        style: pw.TextStyle(color: PdfColors.red),
                      )
                    else if (entry.value > 1)
                      pw.Text('     + ${entry.key} x${entry.value}')
                    else
                      pw.Text('     + ${entry.key}'),
                  pw.SizedBox(height: 10),
                ],
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}*/
