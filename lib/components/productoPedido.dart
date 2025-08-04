import 'package:proyecto_app/components/listaDeProductos.dart';

class ProductoPedido {
  String nombreProducto;
  String urlImagen;
  String descripcionProducto;
  double precioUnitario;
  Map<String, int> ingredientes;

  ProductoPedido({
    required this.nombreProducto,
    required this.urlImagen,
    required this.descripcionProducto,
    required this.precioUnitario,
    required this.ingredientes,
  });

  // Método para copiar el producto
  ProductoPedido copia() {
    return ProductoPedido(
      nombreProducto: nombreProducto,
      urlImagen: urlImagen,
      descripcionProducto: descripcionProducto,
      precioUnitario: precioUnitario,
      ingredientes: Map<String, int>.from(ingredientes),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreProducto': nombreProducto,
      'urlImagen': urlImagen,
      'descripcionProducto': descripcionProducto,
      'ingredientes': ingredientes,
      'precio': precioUnitario,
    };
  }

  static ProductoPedido fromListaDeProductos(ListaDeProductos base) {
    return ProductoPedido(
      nombreProducto: base.nombreProducto,
      urlImagen: base.urlImagen,
      descripcionProducto: base.descripcionProducto,
      precioUnitario: base.precioUnitario,
      ingredientes: Map<String, int>.from(base.ingredientes),
    );
  }
}
