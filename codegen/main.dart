import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dreamflow/services/connectivity_service.dart';
import 'package:dreamflow/services/data_service.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final dataService = DataService();
  await dataService.init();
  final connectivityService = ConnectivityService();
  await connectivityService.init();
  
  runApp(MyApp(
    dataService: dataService,
    connectivityService: connectivityService,
  ));
}

class MyApp extends StatelessWidget {
  final DataService dataService;
  final ConnectivityService connectivityService;
  
  const MyApp({
    Key? key, 
    required this.dataService, 
    required this.connectivityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: dataService),
        ChangeNotifierProvider.value(value: connectivityService),
      ],
      child: MaterialApp(
        title: 'Compagas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
