import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:dreamflow/models/hour_log.dart';
import 'package:dreamflow/models/service.dart';
import 'package:dreamflow/services/data_service.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/widgets/hour_log_card.dart';

class HourLogsScreen extends StatefulWidget {
  const HourLogsScreen({Key? key}) : super(key: key);

  @override
  State<HourLogsScreen> createState() => _HourLogsScreenState();
}

class _HourLogsScreenState extends State<HourLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedType;
  Service? _selectedService;

  final List<String> _logTypes = ['Todos', 'Deslocamento', 'Espera', 'Execuiu00e7iu00e3o'];

  @override
  void initState() {
    super.initState();
    _selectedType = _logTypes.first;
  }

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
          'Apontamentos de Horas',
          style: AppTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          // Filters section
          _buildFilters(),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar apontamentos...',
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
          
          // Hours summary
          _buildHoursSummary(),
          
          // Hour logs list
          Expanded(
            child: _buildHourLogsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final services = dataService.getAllServices();
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service selector
              Text('Serviu00e7o:', style: AppTheme.bodyMedium),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.inactiveColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Service?>(
                    isExpanded: true,
                    value: _selectedService,
                    hint: const Text('Todos os serviu00e7os'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedService = newValue;
                      });
                    },
                    items: [
                      const DropdownMenuItem<Service?>(
                        value: null,
                        child: Text('Todos os serviu00e7os'),
                      ),
                      ...services.map((service) {
                        return DropdownMenuItem<Service?>(
                          value: service,
                          child: Text(
                            service.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Type filter
              Text('Tipo:', style: AppTheme.bodyMedium),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.inactiveColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedType,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                    items: _logTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
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

  Widget _buildHoursSummary() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        List<HourLog> logs = [];
        
        if (_selectedService != null) {
          logs = dataService.getHourLogsForService(_selectedService!.id);
        } else {
          logs = dataService.getAllHourLogs();
        }
        
        // Apply type filter
        if (_selectedType != 'Todos') {
          String typeFilter = '';
          if (_selectedType == 'Deslocamento') typeFilter = 'displacement';
          if (_selectedType == 'Espera') typeFilter = 'waiting';
          if (_selectedType == 'Execuiu00e7iu00e3o') typeFilter = 'execution';
          
          if (typeFilter.isNotEmpty) {
            logs = logs.where((log) => log.type == typeFilter).toList();
          }
        }
        
        // Calculate total hours
        final totalSeconds = logs.fold<int>(
          0, 
          (sum, log) => sum + log.totalTime.inSeconds
        );
        final totalDuration = Duration(seconds: totalSeconds);
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppTheme.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de Horas',
                      style: AppTheme.bodyMedium,
                    ),
                    Text(
                      '${totalDuration.inHours}h ${totalDuration.inMinutes % 60}m',
                      style: AppTheme.titleMedium.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHourLogsList() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        List<HourLog> logs = [];
        
        if (_selectedService != null) {
          logs = dataService.getHourLogsForService(_selectedService!.id);
        } else {
          logs = dataService.getAllHourLogs();
        }
        
        // Apply type filter
        if (_selectedType != 'Todos') {
          String typeFilter = '';
          if (_selectedType == 'Deslocamento') typeFilter = 'displacement';
          if (_selectedType == 'Espera') typeFilter = 'waiting';
          if (_selectedType == 'Execuiu00e7iu00e3o') typeFilter = 'execution';
          
          if (typeFilter.isNotEmpty) {
            logs = logs.where((log) => log.type == typeFilter).toList();
          }
        }
        
        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          // Filter by date in format dd/MM/yyyy
          final dateFormat = DateFormat('dd/MM/yyyy');
          logs = logs.where((log) {
            final startDate = dateFormat.format(log.startTime);
            return startDate.contains(_searchQuery);
          }).toList();
        }

        // Sort by most recent first
        logs.sort((a, b) => b.startTime.compareTo(a.startTime));

        if (logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_off_outlined,
                  size: 72,
                  color: AppTheme.inactiveColor,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'Nenhum apontamento encontrado'
                      : 'Nenhum apontamento de horas',
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
          itemCount: logs.length,
          itemBuilder: (context, index) {
            return HourLogCard(
              hourLog: logs[index],
              onDelete: _showDeleteConfirmation,
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(HourLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusu00e3o', style: AppTheme.titleMedium),
        content: Text(
          'Tem certeza que deseja excluir este apontamento de horas?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: AppTheme.inactiveColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () {
              final dataService = Provider.of<DataService>(context, listen: false);
              dataService.deleteHourLog(log.id);
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
