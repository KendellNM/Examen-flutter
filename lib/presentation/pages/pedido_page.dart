import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/pedido_remote_data_source.dart';
import '../../data/repositories_impl/pedido_repository_impl.dart';
import '../../domain/entity/pedido.dart';

class PedidoPage extends StatefulWidget {
  const PedidoPage({super.key});

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final repository = PedidoRepositoryImpl(PedidoRemoteDataSourceImpl(http.Client()));
  List<Pedido> pedidos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPedidos();
  }

  Future<void> loadPedidos() async {
    setState(() => isLoading = true);
    try {
      final data = await repository.getPedidos();
      setState(() {
        pedidos = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> deletePedido(int id) async {
    try {
      await repository.deletePedido(id);
      loadPedidos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido eliminado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void showPedidoDialog({Pedido? pedido}) {
    final idClienteController = TextEditingController(text: pedido?.idCliente.toString() ?? '');
    final idPlatoController = TextEditingController(text: pedido?.idPlato.toString() ?? '');
    final cantidadController = TextEditingController(text: pedido?.cantidad.toString() ?? '');
    final totalController = TextEditingController(text: pedido?.total.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(pedido == null ? 'Nuevo Pedido' : 'Editar Pedido'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idClienteController,
                decoration: const InputDecoration(labelText: 'ID Cliente'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: idPlatoController,
                decoration: const InputDecoration(labelText: 'ID Plato'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: totalController,
                decoration: const InputDecoration(labelText: 'Total'),
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
              final newPedido = Pedido(
                idPedido: pedido?.idPedido,
                idCliente: int.tryParse(idClienteController.text) ?? 0,
                idPlato: int.tryParse(idPlatoController.text) ?? 0,
                cantidad: int.tryParse(cantidadController.text) ?? 0,
                fecha: DateTime.now(),
                total: double.tryParse(totalController.text) ?? 0,
              );

              try {
                if (pedido == null) {
                  await repository.createPedido(newPedido);
                } else {
                  await repository.updatePedido(pedido.idPedido!, newPedido);
                }
                Navigator.pop(ctx);
                loadPedidos();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(pedido == null ? 'Pedido creado' : 'Pedido actualizado')),
                  );
                }
              } catch (e) {
                Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
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
        title: const Text('Pedidos'),
        backgroundColor: Colors.lightGreen,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
              ? const Center(child: Text('No hay pedidos'))
              : ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.lightGreen.shade100,
                          child: FaIcon(FontAwesomeIcons.cartShopping, color: Colors.lightGreen),
                        ),
                        title: Text('Pedido #${pedido.idPedido}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cliente: ${pedido.idCliente} | Plato: ${pedido.idPlato}'),
                            Text('Cantidad: ${pedido.cantidad}'),
                            Text('Total: \$${pedido.total.toStringAsFixed(2)}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 20),
                              onPressed: () => showPedidoDialog(pedido: pedido),
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.trash, size: 20),
                              color: Colors.red,
                              onPressed: () => deletePedido(pedido.idPedido!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showPedidoDialog(),
        backgroundColor: Colors.lightGreen,
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
