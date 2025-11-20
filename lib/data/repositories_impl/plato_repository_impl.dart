import '../../domain/entity/plato.dart';
import '../../domain/repositories/plato_repository.dart';
import '../datasources/plato_remote_data_source.dart';
import '../plato_model.dart';

class PlatoRepositoryImpl implements PlatoRepository {
  final PlatoRemoteDataSource dataSource;

  PlatoRepositoryImpl(this.dataSource);

  @override
  Future<List<Plato>> getPlatos() async {
    return await dataSource.getAllPlatos();
  }

  @override
  Future<Plato> getPlatoById(int id) async {
    final platos = await dataSource.getAllPlatos();
    return platos.firstWhere((p) => p.idPlato == id);
  }

  @override
  Future<Plato> createPlato(Plato plato) async {
    final platoModel = PlatoModel(
      nombre: plato.nombre,
      descripcion: plato.descripcion,
      precio: plato.precio,
    );
    await dataSource.createPlato(platoModel);
    return platoModel;
  }

  @override
  Future<Plato> updatePlato(int id, Plato plato) async {
    final platoModel = PlatoModel(
      idPlato: id,
      nombre: plato.nombre,
      descripcion: plato.descripcion,
      precio: plato.precio,
    );
    await dataSource.updatePlato(platoModel);
    return platoModel;
  }

  @override
  Future<void> deletePlato(int id) async {
    await dataSource.deletePlato(id);
  }
}
