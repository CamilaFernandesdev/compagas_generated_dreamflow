import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dreamflow/models/service.dart';
import 'package:dreamflow/models/service_order.dart';
import 'package:dreamflow/services/data_service.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/widgets/service_card.dart';
import 'package:dreamflow/screens/service_detail_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  ServiceOrder? _selectedOrder;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Serviu00e7os',
          style: AppTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          // Order selector
          _buildOrderSelector(),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar serviu00e7os...',
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
          
          // Services list
          Expanded(
            child: _buildServicesList(),
          ),
        ],
      ),
      floatingActionButton: _selectedOrder != null
          ? FloatingActionButton(
              onPressed: _showAddServiceDialog,
              backgroundColor: AppTheme.primaryColor,
              heroTag: 'addServiceFab',
              child: const Icon(Icons.add, color: AppTheme.secondaryColor),
            )
          : null,
    );
  }

  Widget _buildOrderSelector() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final orders = dataService.serviceOrders;
        
        if (orders.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Nenhuma ordem de serviu00e7o disponivel.'),
              ),
            ),
          );
        }
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecione uma ordem de serviu00e7o:',
                style: AppTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.inactiveColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ServiceOrder>(
                    isExpanded: true,
                    value: _selectedOrder,
                    hint: const Text('Selecione uma ordem'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOrder = newValue;
                      });
                    },
                    items: orders.map((order) {
                      return DropdownMenuItem<ServiceOrder>(
                        value: order,
                        child: Text(
                          order.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServicesList() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        List<Service> services = [];
        
        if (_selectedOrder != null) {
          services = dataService.getServicesForOrder(_selectedOrder!.id);
        } else {
          services = dataService.getAllServices();
        }
        
        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          services = services.where((service) =>
              service.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              service.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
        }

        if (services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.build_outlined,
                  size: 72,
                  color: AppTheme.inactiveColor,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'Nenhum serviu00e7o encontrado'
                      : _selectedOrder != null
                          ? 'Nenhum serviu00e7o nesta ordem'
                          : 'Nenhum serviu00e7o disponivel',
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
          itemCount: services.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _navigateToServiceDetail(services[index]),
              child: ServiceCard(service: services[index]),
            );
          },
        );
      },
    );
  }

  void _navigateToServiceDetail(Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(service: service),
      ),
    );
  }

  void _showAddServiceDialog() {
    if (_selectedOrder == null) return;
    
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Novo Serviu00e7o', style: AppTheme.titleMedium),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Tu00edtulo',
                  hintText: 'Digite o tu00edtulo do serviu00e7o',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descriu00e7u00e3o',
                  hintText: 'Digite a descriu00e7u00e3o do serviu00e7o',
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
              if (titleController.text.isNotEmpty && _selectedOrder != null) {
                final dataService = Provider.of<DataService>(context, listen: false);
                dataService.addService(
                  _selectedOrder!.id,
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
