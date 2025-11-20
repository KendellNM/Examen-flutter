import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/pedido_remote_data_source.dart';
import '../../data/datasources/cliente_remote_data_source.dart';
import '../../data/datasources/plato_remote_data_source.dart';
import '../../data/repositories_impl/pedido_repository_impl.dart';
import '../../data/repositories_impl/cliente_repository_impl.dart';
import '../../data/repositories_impl/plato_repository_impl.dart';
import '../../domain/entity/pedido.dart';
import '../../domain/entity/cliente.dart';
import '../../domain/entity/plato.dart';

class PedidoPage extends StatefulWidget {
  const PedidoPage({super.key});

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final repository = PedidoRepositoryImpl(PedidoRemoteDataSourceImpl(http.Client()));
  final clienteRepository = ClienteRepositoryImpl(ClienteRemoteDataSourceImpl(http.Client()));
  final platoRepository = PlatoRepositoryImpl(PlatoRemoteDataSourceImpl(http.Client()));
  
  List<Pedido> pedidos = [];
  List<Cliente> clientes = [];
  List<Plato> platos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      final pedidosData = await repository.getPedidos();
      final clientesData = await clienteRepository.getClientes();
      final platosData = await platoRepository.getPlatos();
      
      setState(() {
        pedidos = pedidosData;
        clientes = clientesData;
        platos = platosData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        _showToast('Error al cargar datos: ${e.toString().replaceAll('Exception: ', '')}', isError: true);
      }
    }
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

  Future<void> deletePedido(int id) async {
    try {
      await repository.deletePedido(id);
      loadData();
      if (mounted) {
        _showToast('Pedido eliminado exitosamente');
      }
    } catch (e) {
      if (mounted) {
        _showToast(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  void showPedidoDialog({Pedido? pedido}) {
    Cliente? selectedCliente;
    Plato? selectedPlato;
    
    if (pedido != null) {
      try {
        selectedCliente = clientes.firstWhere(
          (c) => c.idCliente == pedido.cliente.idCliente,
        );
      } catch (e) {
        print('Cliente no encontrado: ${pedido.cliente.idCliente}');
      }
      
      try {
        selectedPlato = platos.firstWhere(
          (p) => p.idPlato == pedido.plato.idPlato,
        );
      } catch (e) {
        print('Plato no encontrado: ${pedido.plato.idPlato}');
      }
    }
    
    final numeroMesaController = TextEditingController(
      text: pedido?.numeroMesa.toString() ?? '1'
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(pedido == null ? 'Nuevo Pedido' : 'Editar Pedido'),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: numeroMesaController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Mesa',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.table_restaurant),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedCliente?.idCliente,
                      decoration: const InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      isExpanded: true,
                      items: clientes.map((cliente) {
                        return DropdownMenuItem<int>(
                          value: cliente.idCliente,
                          child: Text(
                            '${cliente.nombre} - ${cliente.telefono}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCliente = clientes.firstWhere((c) => c.idCliente == value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedPlato?.idPlato,
                      decoration: const InputDecoration(
                        labelText: 'Plato',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.restaurant),
                      ),
                      isExpanded: true,
                      items: platos.map((plato) {
                        return DropdownMenuItem<int>(
                          value: plato.idPlato,
                          child: Text(
                            '${plato.nombre} - S/ ${plato.precio.toStringAsFixed(2)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedPlato = platos.firstWhere((p) => p.idPlato == value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (selectedPlato != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.lightGreen),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio: S/ ${selectedPlato!.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedPlato!.descripcion,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen,
            ),
            onPressed: () async {
              if (selectedCliente == null || selectedPlato == null) {
                _showToast('Por favor complete todos los campos', isError: true);
                return;
              }

              final newPedido = Pedido(
                idPedido: pedido?.idPedido,
                numeroMesa: int.tryParse(numeroMesaController.text) ?? 1,
                plato: selectedPlato!,
                cliente: selectedCliente!,
              );

              try {
                if (pedido == null) {
                  await repository.createPedido(newPedido);
                  Navigator.pop(ctx);
                  loadData();
                  if (mounted) {
                    _showToast('Pedido creado exitosamente');
                  }
                } else {
                  await repository.updatePedido(pedido.idPedido!, newPedido);
                  Navigator.pop(ctx);
                  loadData();
                  if (mounted) {
                    _showToast('Pedido actualizado exitosamente');
                  }
                }
              } catch (e) {
                Navigator.pop(ctx);
                if (mounted) {
                  _showToast(e.toString().replaceAll('Exception: ', ''), isError: true);
                }
              }
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
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
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.lightGreen.shade100,
                                  radius: 20,
                                  child: Text(
                                    '${pedido.numeroMesa}',
                                    style: TextStyle(
                                      color: Colors.lightGreen.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Pedido #${pedido.idPedido} - Mesa ${pedido.numeroMesa}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 16),
                                    color: Colors.blue,
                                    onPressed: () => showPedidoDialog(pedido: pedido),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.trash, size: 16),
                                    color: Colors.red,
                                    onPressed: () => deletePedido(pedido.idPedido!),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.user, size: 12, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    pedido.cliente.nombre,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.phone, size: 12, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(pedido.cliente.telefono),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.utensils, size: 12, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    pedido.plato.nombre,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.attach_money, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'S/ ${pedido.plato.precio.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightGreen.shade700,
                                  ),
                                ),
                              ],
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
