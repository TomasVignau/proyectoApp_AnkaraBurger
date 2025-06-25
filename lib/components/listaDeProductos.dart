class ListaDeProductos {
  String nombreProducto;
  String urlImagen;
  String descripcionProducto;
  int cantidadSeleccionada;
  Map<String, int> ingredientes;

  ListaDeProductos({
    required this.nombreProducto,
    required this.urlImagen,
    required this.descripcionProducto,
    this.cantidadSeleccionada = 0,
    required this.ingredientes,
  });

  // Agrega este factory constructor
  factory ListaDeProductos.fromJson(Map<String, dynamic> json) {
    return ListaDeProductos(
      nombreProducto: json['nombre_Producto'] as String,
      urlImagen: json['imagen'] as String, // Asegúrate que el campo JSON sea 'imagen' o 'Imagen'
      descripcionProducto: json['descripcion'] as String,
      cantidadSeleccionada: 0, // Al cargar desde la API, la cantidad inicial es 0
      ingredientes: (json['ingredientes'] as Map<String, dynamic>).cast<String, int>(),
    );
  }
}