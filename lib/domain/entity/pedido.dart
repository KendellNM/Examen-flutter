class Pedido {
  final int? idPedido;
  final int idCliente;
  final int idPlato;
  final int cantidad;
  final DateTime fecha;
  final double total;

  Pedido({
    this.idPedido,
    required this.idCliente,
    required this.idPlato,
    required this.cantidad,
    required this.fecha,
    required this.total,
  });
}
