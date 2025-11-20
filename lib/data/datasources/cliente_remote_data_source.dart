import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../cliente_model.dart';

abstract class ClienteRemoteDataSource {
  Future<List<ClienteModel>> getAllClientes();
  Future<void> createCliente(ClienteModel cliente);
  Future<void> updateCliente(ClienteModel cliente);
  Future<void> deleteCliente(int id);
}

class ClienteRemoteDataSourceImpl implements ClienteRemoteDataSource {
  final http.Client client;
  final String baseUrl = '${ApiConstants.baseUrl}${ApiConstants.clienteEndpoint}';

  ClienteRemoteDataSourceImpl(this.client);

  @override
  Future<List<ClienteModel>> getAllClientes() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ClienteModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener clientes');
    }
  }

  @override
  Future<void> createCliente(ClienteModel cliente) async {
    await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
  }

  @override
  Future<void> updateCliente(ClienteModel cliente) async {
    await client.put(
      Uri.parse('$baseUrl/${cliente.idCliente}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
  }

  @override
  Future<void> deleteCliente(int id) async {
    await client.delete(Uri.parse('$baseUrl/$id'));
  }
}
