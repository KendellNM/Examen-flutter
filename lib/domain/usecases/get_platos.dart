import '../entity/plato.dart';
import '../repositories/plato_repository.dart';

class GetPlatos {
  final PlatoRepository repository;

  GetPlatos(this.repository);

  Future<List<Plato>> call() async {
    return await repository.getPlatos();
  }
}
