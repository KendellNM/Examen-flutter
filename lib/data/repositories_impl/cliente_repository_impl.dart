import '../../domain/entity/cliente.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../datasources/cliente_remote_data_source.dart';
import '../cliente_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource dataSource;

  ClienteRepositoryImpl(this.dataSource);

  @override
  Future<List<Cliente>> getClientes() async {
    return await dataSource.getAllClientes();
  }

  @override
  Future<Cliente> getClienteById(int id) async {
    final clientes = await dataSource.getAllClientes();
    return clientes.firstWhere((c) => c.idCliente == id);
  }

  @override
  Future<Cliente> createCliente(Cliente cliente) async {
    final clienteModel = ClienteModel(
      nombre: cliente.nombre,
      email: cliente.email,
      telefono: cliente.telefono,
    );
    await dataSource.createCliente(clienteModel);
    return clienteModel;
  }

  @override
  Future<Cliente> updateCliente(int id, Cliente cliente) async {
    final clienteModel = ClienteModel(
      idCliente: id,
      nombre: cliente.nombre,
      email: cliente.email,
      telefono: cliente.telefono,
    );
    await dataSource.updateCliente(clienteModel);
    return clienteModel;
  }

  @override
  Future<void> deleteCliente(int id) async {
    await dataSource.deleteCliente(id);
  }
}
