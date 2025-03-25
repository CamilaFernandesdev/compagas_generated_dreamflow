import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dreamflow/models/service_order.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/screens/services_screen.dart';

class ServiceOrderCard extends StatelessWidget {
  final ServiceOrder serviceOrder;
  
  const ServiceOrderCard({Key? key, required this.serviceOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ServicesScreen()),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      serviceOrder.title,
                      style: AppTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                serviceOrder.description,
                style: AppTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.build,
                        size: 16,
                        color: AppTheme.inactiveColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${serviceOrder.services.length} serviu00e7o${serviceOrder.services.length != 1 ? 's' : ''}',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.inactiveColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Criado em ${DateFormat('dd/MM/yyyy').format(serviceOrder.dateCreated)}',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.inactiveColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;
    
    switch (serviceOrder.status) {
      case 'pending':
        chipColor = Colors.orange;
        statusText = 'Pendente';
        break;
      case 'in_progress':
        chipColor = AppTheme.primaryColor;
        statusText = 'Em Progresso';
        break;
      case 'completed':
        chipColor = AppTheme.successColor;
        statusText = 'Concluu00edda';
        break;
      default:
        chipColor = AppTheme.inactiveColor;
        statusText = 'Desconhecido';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: AppTheme.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
