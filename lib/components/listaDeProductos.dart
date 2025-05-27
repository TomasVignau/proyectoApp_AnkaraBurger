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
    required this.ingredientes
  });
}
