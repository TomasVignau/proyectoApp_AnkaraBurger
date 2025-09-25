/*import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/components/mesa.dart';

class PedidoHelper {
  static Future<bool> actualizarPedido(
    List<ListaDeProductos> listadoProductos,
    Mesa mesaSeleccionada,
  ) async {
    final listadoJson = Uri.encodeComponent(
      jsonEncode(
        listadoProductos.map((producto) => producto.toJson()).toList(),
      ),
    );
    final mesaJson = Uri.encodeComponent(jsonEncode(mesaSeleccionada.toJson()));

    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=subirPedido&listadoProductos=$listadoJson&mesaSeleccionada=$mesaJson', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=subirPedido&listadoProductos=$listadoJson&mesaSeleccionada=$mesaJson', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=subirPedido&listadoProductos=$listadoJson&mesaSeleccionada=$mesaJson',
    );

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['success'] == true;
    } else {
      throw Exception('Error al cambiar estado del pedido');
    }
  }

  static Future<List<ListaDeProductos>> verPedido(
    int idMesa,
  ) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=verPedido&idMesa=$idMesa', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=verPedido&idMesa=$idMesa', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=verPedido&idMesa=$idMesa',
    );

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((jsonItem) => ListaDeProductos.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Error al cargar el pedido. Código: ${response.statusCode}, Cuerpo: ${response.body}');
      }
    }

  static Future<bool> finalizarPedido(
    int idMesa, int estadoPedido
  ) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=finalizarPedido&idMesa=$idMesa&estadoPedido=$estadoPedido', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=finalizarPedido&idMesa=$idMesa&estadoPedido=$estadoPedido', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=finalizarPedido&idMesa=$idMesa&estadoPedido=$estadoPedido',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al finalizar el pedido');
    }
    }

  static Future<String> obtenerFechaYHoraDelPedido(int idMesa) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=obtenerFechaYHoraDelPedido&idMesa=$idMesa', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=verPedido&idMesa=$idMesa', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=verPedido&idMesa=$idMesa',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final String fecha = jsonDecode(response.body);
      return fecha;
      } else {
        throw Exception('Error al devolver al fecha y hora del pedido.');
      }
    }

  static Future<bool> guardarPrecioFinalDelPedido(
    int idMesa, double precioFinal
  ) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=guardarPrecioFinal&idMesa=$idMesa&precioFinal=$precioFinal', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=guardarPrecioFinal&idMesa=$idMesa&precioFinal=$precioFinal', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=guardarPrecioFinal&idMesa=$idMesa&precioFinal=$precioFinal',
    );

    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al cargar el precio del pedido');
    }
    }

  static Future<bool> realizarCambioDeMesa(
    int idMesaActual, int idMesaNueva
  ) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=realizarCambioDeMesa&idMesaActual=$idMesaActual&idMesaNueva=$idMesaNueva', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=realizarCambioDeMesa&idMesaActual=$idMesaActual&idMesaNueva=$idMesaNueva', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=realizarCambioDeMesa&idMesaActual=$idMesaActual&idMesaNueva=$idMesaNueva',
    );

    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al realizar el cambio de mesa.');
    }
    }
    
}*/

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:proyecto_app/components/mesa.dart';

class PedidoHelper {
  /// Agregar o actualizar pedido
  static Future<bool> actualizarPedido(
    List<ListaDeProductos> listadoProductos,
    Mesa mesaSeleccionada,
  ) async {
    final listadoJson = Uri.encodeComponent(
      jsonEncode(
        listadoProductos.map((producto) => producto.toJson()).toList(),
      ),
    );
    final idMesa = mesaSeleccionada.id;

    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/pedidos/agregar_pedido.php?idMesa=$idMesa&productos=$listadoJson',
    );

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al agregar/actualizar pedido');
    }
  }

  /// Ver pedido actual de una mesa
  static Future<List<ListaDeProductos>> verPedido(int idMesa) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/pedidos/ver_pedido.php?idMesa=$idMesa',
    );

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((jsonItem) => ListaDeProductos.fromJson(jsonItem)).toList();
    } else {
      throw Exception(
        'Error al cargar el pedido. Código: ${response.statusCode}, Cuerpo: ${response.body}',
      );
    }
  }

  /// Finalizar un pedido
  static Future<bool> finalizarPedido(int idMesa) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/pedidos/finalizar_pedido.php?idMesa=$idMesa',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al finalizar el pedido');
    }
  }

  /// Obtener fecha y hora del pedido activo
  static Future<String> obtenerFechaYHoraDelPedido(int idMesa) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/pedidos/fecha_hora.php?idMesa=$idMesa',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['fecha_hora'];
    } else {
      throw Exception('Error al devolver la fecha y hora del pedido.');
    }
  }

  /// Guardar precio final del pedido
static Future<bool> guardarPrecioFinalDelPedido(int idMesa, double precioFinal) async {
  final url = Uri.parse(
    'http://10.0.2.2/backEndProyectoApp/pedidos/guardar_precio_final.php?idMesa=$idMesa&precioFinal=$precioFinal',
  );

  final response = await http.get(url);

  print('Status code: ${response.statusCode}');
  print('Raw response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['success'] == true;
  } else {
    throw Exception('Error al guardar el precio final del pedido');
  }
}


  /// Obtener precio final del pedido
  static Future<double> obtenerPrecioFinal(int idMesa) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/pedidos/precio_final.php?idMesa=$idMesa',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['total'] as num).toDouble();
    } else {
      throw Exception('Error al calcular el precio final del pedido');
    }
  }
}
