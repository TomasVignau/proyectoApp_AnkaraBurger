/*import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_app/components/listaDeProductos.dart';

class ProductoHelper {
  // Añade la palabra clave 'static' aquí
  static Future<List<ListaDeProductos>> obtenerProductos() async {
    final response = await http.get(
      //Uri.parse('http://localhost/database.php'),
      Uri.parse('http://10.0.2.2/backEndProyectoApp/database.php?accion=productos'), // PARA ANDROID EMULATOR
      //Uri.parse('http://192.168.0.71/database.php?accion=productos'), //PARA DISPOSITIVOS CONECTADOS A LA RED
      //Uri.parse('http://ankaraburger.kesug.com /database.php?accion=productos'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((jsonItem) {
        return ListaDeProductos.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Fallo al cargar los productos');
    }
  }
}*/

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_app/components/listaDeProductos.dart';

class ProductoHelper {
  static Future<List<ListaDeProductos>> obtenerProductos() async {
    final response = await http.get(
      // Android Emulator
      Uri.parse('http://10.0.2.2/backEndProyectoApp/productos/get_productos.php'),

      // Para dispositivos en la misma red WiFi
      // Uri.parse('http://192.168.0.71/backEndProyectoApp/productos/get_productos.php'),

      // Para hosting externo
      // Uri.parse('http://ankaraburger.kesug.com/backend/productos/get_productos.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((jsonItem) {
        return ListaDeProductos.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Fallo al cargar los productos');
    }
  }
}

