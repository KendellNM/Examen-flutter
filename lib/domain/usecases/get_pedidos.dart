import '../entity/pedido.dart';
import '../repositories/pedido_repository.dart';

class GetPedidos {
  final PedidoRepository repository;

  GetPedidos(this.repository);

  Future<List<Pedido>> call() async {
    return await repository.getPedidos();
  }
}
