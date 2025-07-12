class HamburguesaSeleccionada {
  final String nombre;
  final String imagen;
  final String descripcion;
  final double precio;
  Map<String, int> ingredientes;

  HamburguesaSeleccionada({
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.precio,
    required this.ingredientes,
  });

  HamburguesaSeleccionada copy() {
    return HamburguesaSeleccionada(
      nombre: nombre,
      imagen: imagen,
      descripcion: descripcion,
      precio: precio,
      ingredientes: Map<String, int>.from(ingredientes),
    );
  }
}
