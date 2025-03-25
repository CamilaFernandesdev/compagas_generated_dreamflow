import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:dreamflow/models/service.dart';
import 'package:dreamflow/models/hour_log.dart';
import 'package:dreamflow/services/data_service.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/widgets/hour_log_card.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service service;
  
  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Serviu00e7o',
          style: AppTheme.titleMedium,
        ),
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          // Get fresh data
          final updatedService = dataService.getAllServices()
              .firstWhere((s) => s.id == service.id);
              
          return Column(
            children: [
              // Service details card
              _buildServiceDetailsCard(context, updatedService),
              
              // Hour logs section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Apontamentos de Horas',
                      style: AppTheme.titleSmall,
                    ),
                    if (!updatedService.isCompleted)
                      _buildAddHourLogButton(context, updatedService),
                  ],
                ),
              ),
              
              // Hour logs list
              Expanded(
                child: _buildHourLogsList(context, updatedService, dataService),
              ),
              
              // Complete service button
              if (!updatedService.isCompleted)
                _buildCompleteServiceButton(context, updatedService),
            ],
          );
        },
      ),
    );
  }

  Widget _buildServiceDetailsCard(BuildContext context, Service service) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.title,
                    style: AppTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(service.isCompleted),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tempo Total: ${service.totalTime.inHours}h ${service.totalTime.inMinutes % 60}m',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? AppTheme.successColor : AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        isCompleted ? 'Concluu00eddo' : 'Em andamento',
        style: AppTheme.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHourLogsList(BuildContext context, Service service, DataService dataService) {
    final hourLogs = service.hourLogs;
    
    if (hourLogs.isEmpty) {
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
              'Nenhum apontamento de horas',
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
      itemCount: hourLogs.length,
      itemBuilder: (context, index) {
        return HourLogCard(
          hourLog: hourLogs[index],
          onDelete: service.isCompleted ? null : (log) => _showDeleteConfirmation(context, log),
        );
      },
    );
  }

  Widget _buildAddHourLogButton(BuildContext context, Service service) {
    return ElevatedButton.icon(
      onPressed: () => _showAddHourLogDialog(context, service),
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Adicionar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentColor,
        foregroundColor: AppTheme.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildCompleteServiceButton(BuildContext context, Service service) {
    bool canComplete = service.hourLogs.isNotEmpty;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: canComplete 
            ? () => _showCompleteConfirmation(context, service)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.secondaryColor,
          minimumSize: const Size(double.infinity, 48),
          disabledBackgroundColor: AppTheme.inactiveColor,
        ),
        child: const Text('Finalizar Serviu00e7o'),
      ),
    );
  }

  void _showAddHourLogDialog(BuildContext context, Service service) {
    final selectedType = ValueNotifier<String>('displacement');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Horas', style: AppTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo de hora:', style: AppTheme.bodyMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: selectedType,
              builder: (context, value, child) {
                return Column(
                  children: [
                    _buildTypeRadio(
                      'Deslocamento', 
                      'displacement', 
                      value, 
                      (v) => selectedType.value = v ?? 'displacement'
                    ),
                    _buildTypeRadio(
                      'Espera', 
                      'waiting', 
                      value, 
                      (v) => selectedType.value = v ?? 'waiting'
                    ),
                    _buildTypeRadio(
                      'Execuiu00e7iu00e3o', 
                      'execution', 
                      value, 
                      (v) => selectedType.value = v ?? 'execution'
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: AppTheme.inactiveColor)),
          ),
          ElevatedButton(
            onPressed: () {
              final dataService = Provider.of<DataService>(context, listen: false);
              dataService.addHourLog(service.id, selectedType.value);
              Navigator.pop(context);
            },
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeRadio(String label, String value, String groupValue, Function(String?) onChanged) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showDeleteConfirmation(BuildContext context, HourLog log) {
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

  void _showCompleteConfirmation(BuildContext context, Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Finalizar Serviu00e7o', style: AppTheme.titleMedium),
        content: Text(
          'Tem certeza que deseja finalizar este serviu00e7o? Apu00f3s finalizado, nu00e3o seru00e1 possu00edvel editar os apontamentos.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: AppTheme.inactiveColor)),
          ),
          ElevatedButton(
            onPressed: () {
              final dataService = Provider.of<DataService>(context, listen: false);
              dataService.completeService(service.id);
              Navigator.pop(context);
            },
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }
}
