import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../pedido_model.dart';

abstract class PedidoRemoteDataSource {
  Future<List<PedidoModel>> getAllPedidos();
  Future<void> createPedido(PedidoModel pedido);
  Future<void> updatePedido(PedidoModel pedido);
  Future<void> deletePedido(int id);
}

class PedidoRemoteDataSourceImpl implements PedidoRemoteDataSource {
  final http.Client client;
  final String baseUrl = '${ApiConstants.baseUrl}${ApiConstants.pedidoEndpoint}';

  PedidoRemoteDataSourceImpl(this.client);

  @override
  Future<List<PedidoModel>> getAllPedidos() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => PedidoModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener pedidos');
    }
  }

  @override
  Future<void> createPedido(PedidoModel pedido) async {
    final jsonData = pedido.toJson();
    print('Enviando pedido: $jsonData'); // Debug
    
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jsonData),
    );
    
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al crear pedido');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al crear pedido: ${response.body}');
      }
    }
  }

  @override
  Future<void> updatePedido(PedidoModel pedido) async {
    final jsonData = pedido.toJson();
    print('Actualizando pedido: $jsonData');
    
    final response = await client.put(
      Uri.parse('$baseUrl/${pedido.idPedido}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jsonData),
    );
    
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode != 200) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al actualizar pedido');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al actualizar pedido: ${response.body}');
      }
    }
  }

  @override
  Future<void> deletePedido(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al eliminar pedido');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al eliminar pedido: ${response.body}');
      }
    }
  }
}
