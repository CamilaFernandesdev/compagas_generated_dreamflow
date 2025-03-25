import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  Timer? _mockTimer;
  
  bool get isOnline => _isOnline;
  
  Future<void> init() async {
    // In a real app, you would implement actual connectivity checks here
    // For demo purposes, we'll simulate connectivity changes
    _startMockConnectivityChecks();
  }
  
  void _startMockConnectivityChecks() {
    // Simulates random connectivity changes every 10-20 seconds
    _mockTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      // 80% chance of being online for demo purposes
      _isOnline = (DateTime.now().second % 10 != 0);
      notifyListeners();
    });
  }
  
  // Force app to go online - useful for demo or testing
  void setOnline() {
    _isOnline = true;
    notifyListeners();
  }
  
  // Force app to go offline - useful for demo or testing
  void setOffline() {
    _isOnline = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _mockTimer?.cancel();
    super.dispose();
  }
}
