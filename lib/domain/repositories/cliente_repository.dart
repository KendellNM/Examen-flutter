import '../entity/cliente.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getClientes();
  Future<Cliente> getClienteById(int id);
  Future<Cliente> createCliente(Cliente cliente);
  Future<Cliente> updateCliente(int id, Cliente cliente);
  Future<void> deleteCliente(int id);
}
