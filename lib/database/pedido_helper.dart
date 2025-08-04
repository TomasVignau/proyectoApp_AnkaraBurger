import 'package:http/http.dart' as http;
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
      'http://10.0.2.2/database.php?accion=subirPedido&listadoProductos=$listadoJson&mesaSeleccionada=$mesaJson', //PARA ANDROID EMULATOR
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
      'http://10.0.2.2/database.php?accion=verPedido&idMesa=$idMesa', //PARA ANDROID EMULATOR
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
      'http://10.0.2.2/database.php?accion=finalizarPedido&idMesa=$idMesa&estadoPedido=$estadoPedido', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=finalizarPedido&idMesa=$idMesa&estadoPedido=$estadoPedido', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=finalizarPedido&idMesa=$idMesa&estadoPedido=$estadoPedido',
    );

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al finalizar el pedido');
    }
    }

  static Future<String> obtenerFechaYHoraDelPedido(int idMesa) async {
    final url = Uri.parse(
      'http://10.0.2.2/database.php?accion=obtenerFechaYHoraDelPedido&idMesa=$idMesa', //PARA ANDROID EMULATOR
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
    
}
  

