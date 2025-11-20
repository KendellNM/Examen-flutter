import '../domain/entity/pedido.dart';
import '../domain/entity/cliente.dart';
import '../domain/entity/plato.dart';
import 'cliente_model.dart';
import 'plato_model.dart';

class PedidoModel extends Pedido {
  PedidoModel({
    super.idPedido,
    required super.numeroMesa,
    required super.plato,
    required super.cliente,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      idPedido: json['idPedido'],
      numeroMesa: json['numeroMesa'] ?? 1,
      plato: json['plato'] != null 
          ? PlatoModel.fromJson(json['plato'])
          : PlatoModel(nombre: '', descripcion: '', precio: 0),
      cliente: json['cliente'] != null
          ? ClienteModel.fromJson(json['cliente'])
          : ClienteModel(nombre: '', email: '', telefono: ''),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      if (idPedido != null) 'idPedido': idPedido,
      'numeroMesa': numeroMesa,
      'plato': {
        'idPlato': plato.idPlato ?? 0,
        'nombre': plato.nombre,
        'descripcion': plato.descripcion,
        'precio': plato.precio,
      },
      'cliente': {
        'idCliente': cliente.idCliente ?? 0,
        'nombre': cliente.nombre,
        'email': cliente.email,
        'telefono': cliente.telefono,
      },
    };
    print('PedidoModel.toJson(): $json'); // Debug
    return json;
  }
}
