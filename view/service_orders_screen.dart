import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dreamflow/models/service_order.dart';
import 'package:dreamflow/services/data_service.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/widgets/service_order_card.dart';

class ServiceOrdersScreen extends StatefulWidget {
  const ServiceOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ServiceOrdersScreen> createState() => _ServiceOrdersScreenState();
}

class _ServiceOrdersScreenState extends State<ServiceOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ordens de Serviu00e7o',
          style: AppTheme.titleMedium,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.inactiveColor,
          tabs: const [
            Tab(text: 'Pendentes'),
            Tab(text: 'Em Progresso'),
            Tab(text: 'Concluu00eddas'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar ordens...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList('pending'),
                _buildOrdersList('in_progress'),
                _buildOrdersList('completed'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOrderDialog,
        backgroundColor: AppTheme.primaryColor,
        heroTag: 'addOrderFab',
        child: const Icon(Icons.add, color: AppTheme.secondaryColor),
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final List<ServiceOrder> filteredOrders = dataService.serviceOrders
            .where((order) => order.status == status)
            .where((order) => 
                _searchQuery.isEmpty ||
                order.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                order.description.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 72,
                  color: AppTheme.inactiveColor,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'Nenhuma ordem encontrada'
                      : 'Nenhuma ordem de serviu00e7o',
                  style: AppTheme.titleSmall.copyWith(
                    color: AppTheme.inactiveColor,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            return ServiceOrderCard(serviceOrder: filteredOrders[index]);
          },
        );
      },
    );
  }

  void _showAddOrderDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nova Ordem de Serviu00e7o', style: AppTheme.titleMedium),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Tu00edtulo',
                  hintText: 'Digite o tu00edtulo da ordem',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descriu00e7u00e3o',
                  hintText: 'Digite a descriu00e7u00e3o da ordem',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: AppTheme.inactiveColor)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final dataService = Provider.of<DataService>(context, listen: false);
                dataService.addServiceOrder(
                  titleController.text,
                  descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
