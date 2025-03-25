import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dreamflow/services/connectivity_service.dart';
import 'package:dreamflow/screens/service_orders_screen.dart';
import 'package:dreamflow/screens/services_screen.dart';
import 'package:dreamflow/screens/hour_logs_screen.dart';
import 'package:dreamflow/widgets/timer_dialog.dart';
import 'package:dreamflow/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const ServiceOrdersScreen(),
    const ServicesScreen(),
    const HourLogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: AppTheme.secondaryColor,
        elevation: 8,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.assignment, 'Ordens'),
            _buildNavItem(1, Icons.build, 'Serviços'),
            const SizedBox(width: 48), // Placeholder for FAB
            _buildNavItem(2, Icons.timer, 'Horas'),
            _buildOnlineIndicator(connectivityService.isOnline),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () => _showTimerDialog(),
        child: const Icon(Icons.play_arrow, color: AppTheme.secondaryColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                ? AppTheme.primaryColor 
                : AppTheme.inactiveColor,
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected 
                  ? AppTheme.primaryColor 
                  : AppTheme.inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator(bool isOnline) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 10,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => const TimerDialog(),
    );
  }
}
