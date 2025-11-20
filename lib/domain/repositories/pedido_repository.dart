import '../entity/pedido.dart';

abstract class PedidoRepository {
  Future<List<Pedido>> getPedidos();
  Future<Pedido> getPedidoById(int id);
  Future<Pedido> createPedido(Pedido pedido);
  Future<Pedido> updatePedido(int id, Pedido pedido);
  Future<void> deletePedido(int id);

}
