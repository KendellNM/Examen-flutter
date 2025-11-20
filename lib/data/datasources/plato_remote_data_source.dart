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
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(plato.toJson()),
    );
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al crear plato');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al crear plato: ${response.body}');
      }
    }
  }

  @override
  Future<void> updatePlato(PlatoModel plato) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${plato.idPlato}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(plato.toJson()),
    );
    
    if (response.statusCode != 200) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al actualizar plato');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al actualizar plato: ${response.body}');
      }
    }
  }

  @override
  Future<void> deletePlato(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      try {
        final error = jsonDecode(response.body);
        
        if (error['validationErrors'] != null) {
          final validationErrors = error['validationErrors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.values.join('\n');
          throw Exception(errorMessages);
        }
        
        throw Exception(error['message'] ?? error['error'] ?? 'Error al eliminar plato');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al eliminar plato: ${response.body}');
      }
    }
  }
}
