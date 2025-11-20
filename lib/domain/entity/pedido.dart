import 'cliente.dart';
import 'plato.dart';

class Pedido {
  final int? idPedido;
  final int numeroMesa;
  final Plato plato;
  final Cliente cliente;

  Pedido({
    this.idPedido,
    required this.numeroMesa,
    required this.plato,
    required this.cliente,
  });
}
