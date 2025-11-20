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
    await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );
  }

  @override
  Future<void> updatePedido(PedidoModel pedido) async {
    await client.put(
      Uri.parse('$baseUrl/${pedido.idPedido}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );
  }

  @override
  Future<void> deletePedido(int id) async {
    await client.delete(Uri.parse('$baseUrl/$id'));
  }
}
