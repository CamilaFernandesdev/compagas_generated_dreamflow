import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dreamflow/models/service.dart';
import 'package:dreamflow/services/data_service.dart';
import 'package:dreamflow/theme/app_theme.dart';

class TimerDialog extends StatefulWidget {
  const TimerDialog({Key? key}) : super(key: key);

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  Service? _selectedService;
  String _selectedType = 'displacement';
  
  final List<String> _hourTypes = [
    'displacement', 
    'waiting', 
    'execution'
  ];
  
  final Map<String, String> _hourTypeLabels = {
    'displacement': 'Deslocamento',
    'waiting': 'Espera',
    'execution': 'Execução',
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Iniciar Timer',
        style: AppTheme.titleMedium,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Serviço:',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildServiceSelector(),
            const SizedBox(height: 16),
            Text(
              'Tipo de hora:',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildHourTypeSelector(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: TextStyle(color: AppTheme.inactiveColor),
          ),
        ),
        ElevatedButton(
          onPressed: _selectedService == null ? null : _startTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            disabledBackgroundColor: AppTheme.inactiveColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow, size: 18),
              const SizedBox(width: 8),
              const Text('Iniciar'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSelector() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        // Get all services that are not completed
        final activeServices = dataService.getAllServices()
            .where((service) => !service.isCompleted)
            .toList();
        
        if (activeServices.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Não há serviços disponíveis para adicionar horas.'),
            ),
          );
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.inactiveColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Service>(
              isExpanded: true,
              value: _selectedService,
              hint: const Text('Selecione um serviço'),
              onChanged: (newValue) {
                setState(() {
                  _selectedService = newValue;
                });
              },
              items: activeServices.map((service) {
                return DropdownMenuItem<Service>(
                  value: service,
                  child: Text(
                    service.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHourTypeSelector() {
    return Column(
      children: _hourTypes.map((type) {
        return RadioListTile<String>(
          title: Text(_hourTypeLabels[type] ?? type),
          value: type,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
          activeColor: AppTheme.primaryColor,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  void _startTimer() async {
    if (_selectedService == null) return;
    
    try {
      final dataService = Provider.of<DataService>(context, listen: false);
      await dataService.addHourLog(_selectedService!.id, _selectedType);
      
      if (!mounted) return;
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Timer iniciado para ${_hourTypeLabels[_selectedType] ?? _selectedType}',
          ),
          backgroundColor: AppTheme.primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao iniciar timer: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
