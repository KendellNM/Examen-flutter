import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'presentation/pages/plato_page.dart';
import 'presentation/pages/cliente_page.dart';
import 'presentation/pages/pedido_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Restaurante',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Restaurante'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.cyan.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuCard(
                context,
                title: 'Platos',
                subtitle: 'Gestionar menú del restaurante',
                icon: FontAwesomeIcons.utensils,
                color: Colors.teal,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlatoPage()),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuCard(
                context,
                title: 'Clientes',
                subtitle: 'Administrar clientes',
                icon: FontAwesomeIcons.users,
                color: Colors.cyan,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClientePage()),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuCard(
                context,
                title: 'Pedidos',
                subtitle: 'Ver y crear pedidos',
                icon: FontAwesomeIcons.cartShopping,
                color: Colors.lightGreen,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PedidoPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FaIcon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
              FaIcon(FontAwesomeIcons.chevronRight, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
