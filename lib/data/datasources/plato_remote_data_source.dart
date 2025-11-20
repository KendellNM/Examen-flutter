import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../plato_model.dart';

abstract class PlatoRemoteDataSource {
  Future<List<PlatoModel>> getAllPlatos();
  Future<void> createPlato(PlatoModel plato);
  Future<void> updatePlato(PlatoModel plato);
  Future<void> deletePlato(int id);
}

class PlatoRemoteDataSourceImpl implements PlatoRemoteDataSource {
  final http.Client client;
  final String baseUrl = '${ApiConstants.baseUrl}${ApiConstants.platoEndpoint}';

  PlatoRemoteDataSourceImpl(this.client);

  @override
  Future<List<PlatoModel>> getAllPlatos() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => PlatoModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener platos');
    }
  }

  @override
  Future<void> createPlato(PlatoModel plato) async {
    await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(plato.toJson()),
    );
  }

  @override
  Future<void> updatePlato(PlatoModel plato) async {
    await client.put(
      Uri.parse('$baseUrl/${plato.idPlato}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(plato.toJson()),
    );
  }

  @override
  Future<void> deletePlato(int id) async {
    await client.delete(Uri.parse('$baseUrl/$id'));
  }
}
