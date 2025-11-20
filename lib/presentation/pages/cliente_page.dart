import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/cliente_remote_data_source.dart';
import '../../data/repositories_impl/cliente_repository_impl.dart';
import '../../domain/entity/cliente.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final repository = ClienteRepositoryImpl(ClienteRemoteDataSourceImpl(http.Client()));
  List<Cliente> clientes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadClientes();
  }

  Future<void> loadClientes() async {
    setState(() => isLoading = true);
    try {
      final data = await repository.getClientes();
      setState(() {
        clientes = data;
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

  Future<void> deleteCliente(int id) async {
    try {
      await repository.deleteCliente(id);
      loadClientes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente eliminado')),
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

  void showClienteDialog({Cliente? cliente}) {
    final nombreController = TextEditingController(text: cliente?.nombre ?? '');
    final emailController = TextEditingController(text: cliente?.email ?? '');
    final telefonoController = TextEditingController(text: cliente?.telefono ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(cliente == null ? 'Nuevo Cliente' : 'Editar Cliente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
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
              final newCliente = Cliente(
                idCliente: cliente?.idCliente,
                nombre: nombreController.text,
                email: emailController.text,
                telefono: telefonoController.text,
              );

              try {
                if (cliente == null) {
                  await repository.createCliente(newCliente);
                } else {
                  await repository.updateCliente(cliente.idCliente!, newCliente);
                }
                Navigator.pop(ctx);
                loadClientes();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(cliente == null ? 'Cliente creado' : 'Cliente actualizado')),
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
        title: const Text('Clientes'),
        backgroundColor: Colors.cyan,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : clientes.isEmpty
              ? const Center(child: Text('No hay clientes'))
              : ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.cyan.shade100,
                          child: FaIcon(FontAwesomeIcons.user, color: Colors.cyan),
                        ),
                        title: Text(cliente.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cliente.email),
                            Text(cliente.telefono),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 20),
                              onPressed: () => showClienteDialog(cliente: cliente),
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.trash, size: 20),
                              color: Colors.red,
                              onPressed: () => deleteCliente(cliente.idCliente!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showClienteDialog(),
        backgroundColor: Colors.cyan,
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
