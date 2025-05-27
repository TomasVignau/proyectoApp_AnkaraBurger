import 'dart:io';
import 'package:flutter/services.dart';
import 'package:proyecto_app/components/listaDeProductos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // para saber si estás en modo debug

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  DataBaseHelper._internal();
  static DataBaseHelper get instance =>
      _dataBaseHelper ??= DataBaseHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    await init();
    return _db!;
  }

  /*Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ankaraBaseDeDatos.db");

    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load(
        "assets/database/ankaraBaseDeDatos.db",
      );
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(path);
  }*/

  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ankaraBaseDeDatos.db");

    // SOLO en modo debug: borrar y copiar base desde assets
    if (kDebugMode && await File(path).exists()) {
      await File(path).delete();
    }

    // Si no existe (o fue borrada), copiar desde assets
    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load(
        "assets/database/ankaraBaseDeDatos.db",
      );
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(path);
  }

  // Leer productos con precio y disponibilidad
  Future<List<Map<String, dynamic>>> obtenerProductosConPrecio() async {
    final dbClient = await db;
    return await dbClient.query("PRODUCTOSYPRECIO");
  }

  /*// Leer ingredientes por id
  Future<Map<String, int>> obtenerIngredientes(int idProducto) async {
    final dbClient = await db;
    final result = await dbClient.query(
      "PRODUCTOSINGREDIENTES",
      where: "id_Producto = ?",
      whereArgs: [idProducto],
    );
    if (result.isNotEmpty) {
      return Map<String, int>.from(result.first)..remove('id_Producto');
    }
    return {};
  }*/

  /*Future<List<ListaDeProductos>> obtenerProductos() async {
    final dbClient = await db;

    final resultado = await dbClient.rawQuery('''
    SELECT p.nombre_Producto, p.imagen, d.descripcion
    FROM PRODUCTOSYPRECIO p
    JOIN PRODUCTOSYDESCRIPCION d ON p.id_Producto = d.id_Producto
    WHERE p.disponible = 1
  ''');

    for (var element in resultado) {
      print("$element");
    }

    return resultado.map((fila) {
      return ListaDeProductos(
        nombreProducto: fila['nombre_Producto'] as String,
        urlImagen: "assets/images/${fila['imagen']}",
        descripcionProducto: fila['descripcion'] as String,
        cantidadSeleccionada: 0,
      );
    }).toList();
  }*/

  /*Future<List<ListaDeProductos>> obtenerProductos() async {
    final dbClient = await db;

    final resultado = await dbClient.rawQuery('''
    SELECT p.nombre_Producto, p.imagen, d.descripcion, 
       i.panDePatata, i.carne, i.cheddar, i.bacon, i.tomate, 
       i.lechuga, i.cebollaCaramelizada, i.salsaAnkara
    FROM PRODUCTOSYPRECIO p
    JOIN PRODUCTOSYDESCRIPCION d ON p.id_Producto = d.id_Producto
    LEFT JOIN PRODUCTOSEINGREDIENTES i ON p.id_Producto = i.id_Producto
  ''');

    for (var element in resultado) {
      print("$element");
    }

    return resultado.map((fila) {
      return ListaDeProductos(
        nombreProducto: fila['nombre_Producto'] as String,
        urlImagen: "assets/images/${fila['imagen']}",
        descripcionProducto: fila['descripcion'] as String,
        cantidadSeleccionada: 0,
        ingredientes: {
          'Pan de papa': (fila['panDePatata'] as int?) ?? 0,
          'Carne': (fila['carne'] as int?) ?? 0,
          'Cheddar': (fila['cheddar'] as int?) ?? 0,
          'Bacon': (fila['bacon'] as int?) ?? 0,
          'Tomate': (fila['tomate'] as int?) ?? 0,
          'Lechuga': (fila['lechuga'] as int?) ?? 0,
          'Cebolla caramelizada': (fila['cebollaCaramelizada'] as int?) ?? 0,
          'Salsa Ankara': (fila['salsaAnkara'] as int?) ?? 0,
        },
      );
    }).toList();
  }*/

  Future<List<ListaDeProductos>> obtenerProductos() async {
    final dbClient = await db;

    // Consulta para productos que tienen ingredientes (comidas)
    final comidas = await dbClient.rawQuery('''
    SELECT p.nombre_Producto, p.imagen, d.descripcion, 
           i.panDePatata, i.carne, i.cheddar, i.bacon, i.tomate, 
           i.lechuga, i.cebollaCaramelizada, i.salsaAnkara
    FROM PRODUCTOSYPRECIO p
    JOIN PRODUCTOSYDESCRIPCION d ON p.id_Producto = d.id_Producto
    JOIN PRODUCTOSEINGREDIENTES i ON p.id_Producto = i.id_Producto
  ''');

    // Consulta para productos que NO tienen ingredientes (bebidas)
    final bebidas = await dbClient.rawQuery('''
    SELECT p.nombre_Producto, p.imagen, d.descripcion
    FROM PRODUCTOSYPRECIO p
    JOIN PRODUCTOSYDESCRIPCION d ON p.id_Producto = d.id_Producto
    WHERE p.id_Producto NOT IN (
      SELECT id_Producto FROM PRODUCTOSEINGREDIENTES
    )
  ''');

    // Mapeo de comidas con ingredientes
    final productosComidas =
        comidas.map((fila) {
          return ListaDeProductos(
            nombreProducto: fila['nombre_Producto'] as String,
            urlImagen: "assets/images/${fila['imagen']}",
            descripcionProducto: fila['descripcion'] as String,
            cantidadSeleccionada: 0,
            ingredientes: {
              'Pan de papa': (fila['panDePatata'] as int?) ?? 0,
              'Carne': (fila['carne'] as int?) ?? 0,
              'Cheddar': (fila['cheddar'] as int?) ?? 0,
              'Bacon': (fila['bacon'] as int?) ?? 0,
              'Tomate': (fila['tomate'] as int?) ?? 0,
              'Lechuga': (fila['lechuga'] as int?) ?? 0,
              'Cebolla caramelizada':
                  (fila['cebollaCaramelizada'] as int?) ?? 0,
              'Salsa Ankara': (fila['salsaAnkara'] as int?) ?? 0,
            },
          );
        }).toList();

    // Mapeo de bebidas sin ingredientes
    final productosBebidas =
        bebidas.map((fila) {
          return ListaDeProductos(
            nombreProducto: fila['nombre_Producto'] as String,
            urlImagen: "assets/images/${fila['imagen']}",
            descripcionProducto: fila['descripcion'] as String,
            cantidadSeleccionada: 0,
            ingredientes: {}, // sin ingredientes
          );
        }).toList();

    // Unir ambos tipos de productos
    return [...productosComidas, ...productosBebidas];
  }
}
