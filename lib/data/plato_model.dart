import '../domain/entity/plato.dart';

class PlatoModel extends Plato {
  PlatoModel({
    super.idPlato,
    required super.nombre,
    required super.descripcion,
    required super.precio,
  });

  factory PlatoModel.fromJson(Map<String, dynamic> json) {
    return PlatoModel(
      idPlato: json['idPlato'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idPlato != null) 'idPlato': idPlato,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
    };
  }
}
