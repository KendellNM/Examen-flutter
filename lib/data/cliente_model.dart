import '../domain/entity/cliente.dart';

class ClienteModel extends Cliente {
  ClienteModel({
    super.idCliente,
    required super.nombre,
    required super.email,
    required super.telefono,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      idCliente: json['idCliente'],
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idCliente != null) 'idCliente': idCliente,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
    };
  }
}
