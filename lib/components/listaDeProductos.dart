import 'package:uuid/uuid.dart';

class ListaDeProductos {
  String uuid; // identificador único por unidad
  int? idProducto;
  String nombreProducto;
  String urlImagen;
  String descripcionProducto;
  int cantidadSeleccionada;
  Map<String, int> ingredientes;
  List<Map<String, int>> ingredientesPorUnidad; // 👈 nuevo campo
  double precioUnitario;
  String tipo;

  ListaDeProductos({
    String? uuid,
    this.idProducto,
    required this.nombreProducto,
    required this.urlImagen,
    required this.descripcionProducto,
    this.cantidadSeleccionada = 0,
    required this.ingredientes,
    List<Map<String, int>>? ingredientesPorUnidad, // 👈 constructor opcional
    required this.precioUnitario,
    required this.tipo,
  }) : uuid = uuid ?? const Uuid().v4(),
       ingredientesPorUnidad =
           ingredientesPorUnidad ??
           [
             Map<String, int>.from(ingredientes),
           ]; // 👈 inicialización por defecto // si no viene, generamos un id único

  factory ListaDeProductos.fromJson(Map<String, dynamic> json) {
    final ing =
        (json['ingredientes'] as Map<String, dynamic>).cast<String, int>();

    return ListaDeProductos(
      idProducto:
          json['id_Producto'] != null
              ? int.tryParse(json['id_Producto'].toString())
              : null,
      nombreProducto: json['nombre_Producto'] as String,
      urlImagen: json['imagen'] as String,
      descripcionProducto: json['descripcion'] as String,
      cantidadSeleccionada: json['cantidad_seleccionada'] ?? 0,
      ingredientes: ing,
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
      tipo: json['tipo'] as String? ?? '',
      ingredientesPorUnidad:
          json['ingredientesPorUnidad'] != null
              ? (json['ingredientesPorUnidad'] as List)
                  .map((e) => (e as Map).cast<String, int>())
                  .toList()
              : [
                Map<String, int>.from(ing),
              ], // si no viene, inicializa con base
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'uuid': uuid,
      'nombreProducto': nombreProducto,
      'urlImagen': urlImagen,
      'descripcionProducto': descripcionProducto,
      'cantidadSeleccionada': cantidadSeleccionada,
      'ingredientes': ingredientes,
      'ingredientes_por_unidad':
          ingredientesPorUnidad, // 👈 nuevo campo en JSON
      'precio': precioUnitario,
      'tipo': tipo,
    };
    if (idProducto != null) map['id_Producto'] = idProducto!;
    return map;
  }
}
