import '../entity/plato.dart';

abstract class PlatoRepository {
  Future<List<Plato>> getPlatos();
  Future<Plato> getPlatoById(int id);
  Future<Plato> createPlato(Plato plato);
  Future<Plato> updatePlato(int id, Plato plato);
  Future<void> deletePlato(int id);
}
