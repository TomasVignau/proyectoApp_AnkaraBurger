class ListaDeProductos {
  int? idProducto;
  String nombreProducto;
  String urlImagen;
  String descripcionProducto;
  int cantidadSeleccionada;
  Map<String, int> ingredientes;
  double precioUnitario;

  ListaDeProductos({
    this.idProducto,
    required this.nombreProducto,
    required this.urlImagen,
    required this.descripcionProducto,
    this.cantidadSeleccionada = 0,
    required this.ingredientes,
    required this.precioUnitario,
  });

  factory ListaDeProductos.fromJson(Map<String, dynamic> json) {
    return ListaDeProductos(
      idProducto: json['id_Producto'] != null ? int.tryParse(json['id_Producto'].toString()) : null,
      nombreProducto: json['nombre_Producto'] as String,
      urlImagen: json['imagen'] as String,
      descripcionProducto: json['descripcion'] as String,
      cantidadSeleccionada: json['cantidad_seleccionada'] ?? 0,
      ingredientes: (json['ingredientes'] as Map<String, dynamic>).cast<String, int>(),
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'nombreProducto': nombreProducto,
      'urlImagen': urlImagen,
      'descripcionProducto': descripcionProducto,
      'cantidadSeleccionada': cantidadSeleccionada,
      'ingredientes': ingredientes,
      'precio': precioUnitario,
    };
    if (idProducto != null) map['id_Producto'] = idProducto!;
    return map;
  }
}