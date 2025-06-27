class Mesa {
  final int id;
  final int estado;

  Mesa({
    required this.id,
    required this.estado,
  });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      id: int.parse(json['id_Mesa'].toString()),
      estado: int.parse(json['EstadoPedido'].toString()),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mesa &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Mesa $id';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estado': estado,
    };
  }
}
