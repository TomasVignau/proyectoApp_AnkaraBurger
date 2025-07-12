import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_app/components/mesa.dart';

class MesaHelper {
  // Añade la palabra clave 'static' aquí
  static Future<List<Mesa>> obtenerMesas() async {
    final response = await http.get(
      //Uri.parse('http://localhost/database.php'),
      Uri.parse(
        'http://10.0.2.2/database.php?accion=mesas',
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
      'http://10.0.2.2/database.php?accion=mesaEstado&id=$idMesa&estado=$nuevoEstado', //PARA ANDROID EMULATOR
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
      'http://10.0.2.2/database.php?accion=verEstadoMesa&id=$idMesa', //PARA ANDROID EMULATOR
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
}
