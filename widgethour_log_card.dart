import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dreamflow/models/hour_log.dart';
import 'package:dreamflow/theme/app_theme.dart';

class HourLogCard extends StatelessWidget {
  final HourLog hourLog;
  final Function(HourLog)? onDelete;
  
  const HourLogCard({
    Key? key, 
    required this.hourLog, 
    this.onDelete,
  }) : super(key: key);

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
                _buildTypeChip(),
                if (hourLog.isRunning)
                  _buildRunningChip(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    'Inu00edcio',
                    hourLog.startTime,
                    Icons.play_arrow_rounded,
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppTheme.inactiveColor.withOpacity(0.3),
                ),
                Expanded(
                  child: hourLog.endTime != null
                      ? _buildTimeInfo(
                          'Fim',
                          hourLog.endTime!,
                          Icons.stop_rounded,
                        )
                      : const Center(
                          child: Text('Em andamento...'),
                        ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDurationInfo(),
                if (onDelete != null && !hourLog.isRunning)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: () => onDelete!(hourLog),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    String typeText;
    Color typeColor;
    IconData typeIcon;
    
    switch (hourLog.type) {
      case 'displacement':
        typeText = 'Deslocamento';
        typeColor = Colors.blue;
        typeIcon = Icons.drive_eta;
        break;
      case 'waiting':
        typeText = 'Espera';
        typeColor = Colors.orange;
        typeIcon = Icons.hourglass_empty;
        break;
      case 'execution':
        typeText = 'Execuiu00e7iu00e3o';
        typeColor = AppTheme.primaryColor;
        typeIcon = Icons.build;
        break;
      default:
        typeText = 'Outro';
        typeColor = AppTheme.inactiveColor;
        typeIcon = Icons.more_horiz;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: typeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            typeIcon,
            size: 16,
            color: typeColor,
          ),
          const SizedBox(width: 6),
          Text(
            typeText,
            style: AppTheme.bodySmall.copyWith(
              color: typeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Em andamento',
            style: AppTheme.bodySmall.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, DateTime time, IconData icon) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.inactiveColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeFormat.format(time),
            style: AppTheme.titleMedium,
          ),
          Text(
            dateFormat.format(time),
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationInfo() {
    final duration = hourLog.totalTime;
    
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60);
    final seconds = (duration.inSeconds % 60);
    
    String durationText;
    if (hours > 0) {
      durationText = '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      durationText = '${minutes}m ${seconds}s';
    } else {
      durationText = '${seconds}s';
    }
    
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 18,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          'Duração: $durationText',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
