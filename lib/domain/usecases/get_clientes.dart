import '../entity/cliente.dart';
import '../repositories/cliente_repository.dart';

class GetClientes {
  final ClienteRepository repository;

  GetClientes(this.repository);

  Future<List<Cliente>> call() async {
    return await repository.getClientes();
  }
}
