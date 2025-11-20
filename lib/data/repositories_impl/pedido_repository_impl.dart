import '../../domain/entity/pedido.dart';
import '../../domain/repositories/pedido_repository.dart';
import '../datasources/pedido_remote_data_source.dart';
import '../pedido_model.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoRemoteDataSource dataSource;

  PedidoRepositoryImpl(this.dataSource);

  @override
  Future<List<Pedido>> getPedidos() async {
    return await dataSource.getAllPedidos();
  }

  @override
  Future<Pedido> getPedidoById(int id) async {
    final pedidos = await dataSource.getAllPedidos();
    return pedidos.firstWhere((p) => p.idPedido == id);
  }

  @override
  Future<Pedido> createPedido(Pedido pedido) async {
    final pedidoModel = PedidoModel(
      idCliente: pedido.idCliente,
      idPlato: pedido.idPlato,
      cantidad: pedido.cantidad,
      fecha: pedido.fecha,
      total: pedido.total,
    );
    await dataSource.createPedido(pedidoModel);
    return pedidoModel;
  }

  @override
  Future<Pedido> updatePedido(int id, Pedido pedido) async {
    final pedidoModel = PedidoModel(
      idPedido: id,
      idCliente: pedido.idCliente,
      idPlato: pedido.idPlato,
      cantidad: pedido.cantidad,
      fecha: pedido.fecha,
      total: pedido.total,
    );
    await dataSource.updatePedido(pedidoModel);
    return pedidoModel;
  }

  @override
  Future<void> deletePedido(int id) async {
    await dataSource.deletePedido(id);
  }
}
