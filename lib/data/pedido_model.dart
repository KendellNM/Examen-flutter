import '../domain/entity/pedido.dart';

class PedidoModel extends Pedido {
  PedidoModel({
    super.idPedido,
    required super.idCliente,
    required super.idPlato,
    required super.cantidad,
    required super.fecha,
    required super.total,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      idPedido: json['idPedido'],
      idCliente: json['idCliente'] ?? 0,
      idPlato: json['idPlato'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
      fecha: json['fecha'] != null 
          ? DateTime.parse(json['fecha']) 
          : DateTime.now(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idPedido != null) 'idPedido': idPedido,
      'idCliente': idCliente,
      'idPlato': idPlato,
      'cantidad': cantidad,
      'fecha': fecha.toIso8601String(),
      'total': total,
    };
  }
}
