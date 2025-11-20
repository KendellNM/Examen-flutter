import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/plato_remote_data_source.dart';
import '../../data/repositories_impl/plato_repository_impl.dart';
import '../../domain/entity/plato.dart';

class PlatoPage extends StatefulWidget {
  const PlatoPage({super.key});

  @override
  State<PlatoPage> createState() => _PlatoPageState();
}

class _PlatoPageState extends State<PlatoPage> {
  final repository = PlatoRepositoryImpl(PlatoRemoteDataSourceImpl(http.Client()));
  List<Plato> platos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPlatos();
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> loadPlatos() async {
    setState(() => isLoading = true);
    try {
      final data = await repository.getPlatos();
      setState(() {
        platos = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        _showToast('Error al cargar platos: ${e.toString().replaceAll('Exception: ', '')}', isError: true);
      }
    }
  }

  Future<void> deletePlato(int id) async {
    try {
      await repository.deletePlato(id);
      loadPlatos();
      if (mounted) {
        _showToast('Plato eliminado exitosamente');
      }
    } catch (e) {
      if (mounted) {
        _showToast(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  void showPlatoDialog({Plato? plato}) {
    final nombreController = TextEditingController(text: plato?.nombre ?? '');
    final descripcionController = TextEditingController(text: plato?.descripcion ?? '');
    final precioController = TextEditingController(text: plato?.precio.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(plato == null ? 'Nuevo Plato' : 'Editar Plato'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio (S/)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final newPlato = Plato(
                idPlato: plato?.idPlato,
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                precio: double.tryParse(precioController.text) ?? 0,
              );

              try {
                if (plato == null) {
                  await repository.createPlato(newPlato);
                  Navigator.pop(ctx);
                  loadPlatos();
                  if (mounted) {
                    _showToast('Plato creado exitosamente');
                  }
                } else {
                  await repository.updatePlato(plato.idPlato!, newPlato);
                  Navigator.pop(ctx);
                  loadPlatos();
                  if (mounted) {
                    _showToast('Plato actualizado exitosamente');
                  }
                }
              } catch (e) {
                Navigator.pop(ctx);
                if (mounted) {
                  _showToast(e.toString().replaceAll('Exception: ', ''), isError: true);
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platos'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : platos.isEmpty
              ? const Center(child: Text('No hay platos'))
              : ListView.builder(
                  itemCount: platos.length,
                  itemBuilder: (context, index) {
                    final plato = platos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: FaIcon(FontAwesomeIcons.utensils, color: Colors.teal),
                        ),
                        title: Text(plato.nombre),
                        subtitle: Text(plato.descripcion),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'S/ ${plato.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 20),
                              onPressed: () => showPlatoDialog(plato: plato),
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.trash, size: 20),
                              color: Colors.red,
                              onPressed: () => deletePlato(plato.idPlato!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showPlatoDialog(),
        backgroundColor: Colors.teal,
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
