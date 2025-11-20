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
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al crear cliente');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al crear cliente: ${response.body}');
      }
    }
  }

  @override
  Future<void> updateCliente(ClienteModel cliente) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${cliente.idCliente}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
    
    if (response.statusCode != 200) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al actualizar cliente');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al actualizar cliente: ${response.body}');
      }
    }
  }

  @override
  Future<void> deleteCliente(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al eliminar cliente');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al eliminar cliente: ${response.body}');
      }
    }
  }
}
