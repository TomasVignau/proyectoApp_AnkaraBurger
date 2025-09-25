/*import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_app/components/mesa.dart';

class MesaHelper {
  // Añade la palabra clave 'static' aquí
  static Future<List<Mesa>> obtenerMesas() async {
    final response = await http.get(
      //Uri.parse('http://localhost/database.php'),
      Uri.parse(
        'http://10.0.2.2/backEndProyectoApp/database.php?accion=mesas',
      ), //PARA ANDROID EMULATOR
      //Uri.parse('http://192.168.0.71/database.php?accion=mesas'), //PARA DISPOSITIVOS CONECTADOS A LA RED
      //Uri.parse('http://ankaraburger.kesug.com/database.php?accion=mesas'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((jsonItem) {
        return Mesa.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Fallo al cargar los productos');
    }
  }

  static Future<bool> cambiarEstadoMesa(int idMesa, int nuevoEstado) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=mesaEstado&id=$idMesa&estado=$nuevoEstado', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=mesaEstado&id=$idMesa&estado=$nuevoEstado', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=mesaEstado&id=$idMesa&estado=$nuevoEstado',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al cambiar estado de la mesa');
    }
  }

  static Future<int> verEstadoMesa(int idMesa) async {
    final url = Uri.parse(
      'http://10.0.2.2/backEndProyectoApp/database.php?accion=verEstadoMesa&id=$idMesa', //PARA ANDROID EMULATOR
      //'http://192.168.0.71/database.php?accion=mesaEstado&id=$idMesa&estado=$nuevoEstado', //PARA DISPOSITIVOS CONECTADOS A LA RED
      //'http://ankaraburger.kesug.com/database.php?accion=mesaEstado&id=$idMesa&estado=$nuevoEstado',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final int estado = jsonDecode(response.body);
      return estado;
    } else {
      throw Exception('Error al ver el estado de la mesa');
    }
  }
}*/

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_app/components/mesa.dart';

class MesaHelper {
  static Future<List<Mesa>> obtenerMesas() async {
    final response = await http.get(
      // Android Emulator
      Uri.parse('http://10.0.2.2/backEndProyectoApp/mesas/get_mesas.php'),

      // Para dispositivos en la misma red WiFi
      // Uri.parse('http://192.168.0.71/backEndProyectoApp/mesas/get_mesas.php'),

      // Para hosting externo
      // Uri.parse('http://ankaraburger.kesug.com/mesas/get_mesas.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((jsonItem) {
        return Mesa.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Fallo al cargar las mesas');
    }
  }

  static Future<bool> cambiarEstadoMesa(int idMesa, int nuevoEstado) async {
    final response = await http.get(
      // Android Emulator
      Uri.parse(
          'http://10.0.2.2/backEndProyectoApp/mesas/cambiar_estado.php?&id=$idMesa&estado=$nuevoEstado'),

      // Para dispositivos en la misma red WiFi
      // Uri.parse(
      //     'http://192.168.0.71/backEndProyectoApp/mesas/cambiar_estado.php?&id=$idMesa&estado=$nuevoEstado'),

      // Para hosting externo
      // Uri.parse(
      //     'http://ankaraburger.kesug.com/mesas/cambiar_estado.php?&id=$idMesa&estado=$nuevoEstado'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al cambiar estado de la mesa');
    }
  }

  static Future<int> verEstadoMesa(int idMesa) async {
    final response = await http.get(
      // Android Emulator
      Uri.parse(
          'http://10.0.2.2/backEndProyectoApp/mesas/ver_estado.php?&id=$idMesa'),

      // Para dispositivos en la misma red WiFi
      // Uri.parse(
      //     'http://192.168.0.71/backEndProyectoApp/mesas/ver_estado.php?&id=$idMesa'),

      // Para hosting externo
      // Uri.parse(
      //     'http://ankaraburger.kesug.com/mesas/ver_estado.php?&id=$idMesa'),
    );

    if (response.statusCode == 200) {
      final int estado = jsonDecode(response.body);
      return estado;
    } else {
      throw Exception('Error al ver el estado de la mesa');
    }
  }

  static Future<bool> realizarCambioDeMesa(
    int idMesaActual, int idMesaNueva
  ) async {
    final response = await http.get(
      // Android Emulator
      Uri.parse(
          'http://10.0.2.2/backEndProyectoApp/mesas/cambio_de_mesa.php?idMesaActual=$idMesaActual&idMesaNueva=$idMesaNueva'),

      // Para dispositivos en la misma red WiFi
      // Uri.parse(
      //     'http://192.168.0.71/backEndProyectoApp/mesas/cambio_de_mesa.php?idMesaActual=$idMesaActual&idMesaNueva=$idMesaNueva'),

      // Para hosting externo
      // Uri.parse(
      //     'http://ankaraburger.kesug.com/mesas/cambio_de_mesa.php?idMesaActual=$idMesaActual&idMesaNueva=$idMesaNueva'),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al realizar el cambio de mesa.');
    }
  }

}