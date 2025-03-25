import 'package:flutter/material.dart';

import 'package:dreamflow/models/service.dart';
import 'package:dreamflow/theme/app_theme.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  
  const ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    service.title,
                    style: AppTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: AppTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  Icons.timer_outlined, 
                  '${service.totalTime.inHours}h ${service.totalTime.inMinutes % 60}m',
                ),
                _buildInfoItem(
                  Icons.note_alt_outlined,
                  '${service.hourLogs.length} apontamento${service.hourLogs.length != 1 ? 's' : ''}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;
    
    if (service.isCompleted) {
      chipColor = AppTheme.successColor;
      statusText = 'Concluu00eddo';
    } else {
      switch (service.status) {
        case 'pending':
          chipColor = Colors.orange;
          statusText = 'Pendente';
          break;
        case 'in_progress':
          chipColor = AppTheme.primaryColor;
          statusText = 'Em Andamento';
          break;
        default:
          chipColor = AppTheme.inactiveColor;
          statusText = 'Desconhecido';
      }
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

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
