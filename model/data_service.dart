import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:dreamflow/models/service_order.dart';
import 'package:dreamflow/models/service.dart';
import 'package:dreamflow/models/hour_log.dart';

class DataService extends ChangeNotifier {
  late SharedPreferences _prefs;
  final _uuid = const Uuid();
  
  List<ServiceOrder> _serviceOrders = [];
  
  List<ServiceOrder> get serviceOrders => _serviceOrders;
  
  // Initialize the service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadData();
  }
  
  // Load data from SharedPreferences
  void _loadData() {
    final ordersJson = _prefs.getStringList('serviceOrders') ?? [];
    _serviceOrders = ordersJson
        .map((json) => ServiceOrder.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }
  
  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final ordersJson = _serviceOrders
        .map((order) => jsonEncode(order.toJson()))
        .toList();
    await _prefs.setStringList('serviceOrders', ordersJson);
    notifyListeners();
  }
  
  // Get all services across all service orders
  List<Service> getAllServices() {
    return _serviceOrders.expand((order) => order.services).toList();
  }
  
  // Get all hour logs across all services
  List<HourLog> getAllHourLogs() {
    return getAllServices().expand((service) => service.hourLogs).toList();
  }
  
  // Get services for a specific service order
  List<Service> getServicesForOrder(String orderId) {
    final order = _serviceOrders.firstWhere((order) => order.id == orderId);
    return order.services;
  }
  
  // Get hour logs for a specific service
  List<HourLog> getHourLogsForService(String serviceId) {
    for (final order in _serviceOrders) {
      for (final service in order.services) {
        if (service.id == serviceId) {
          return service.hourLogs;
        }
      }
    }
    return [];
  }
  
  // Add a new service order
  Future<ServiceOrder> addServiceOrder(String title, String description) async {
    final newOrder = ServiceOrder(
      id: _uuid.v4(),
      title: title,
      description: description,
      dateCreated: DateTime.now(),
      status: 'pending',
      services: [],
    );
    
    _serviceOrders.add(newOrder);
    await _saveData();
    return newOrder;
  }
  
  // Add a service to a service order
  Future<Service> addService(String orderId, String title, String description) async {
    final newService = Service(
      id: _uuid.v4(),
      serviceOrderId: orderId,
      title: title,
      description: description,
      status: 'pending',
      hourLogs: [],
      isCompleted: false,
    );
    
    final orderIndex = _serviceOrders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final updatedServices = [..._serviceOrders[orderIndex].services, newService];
      _serviceOrders[orderIndex] = _serviceOrders[orderIndex].copyWith(services: updatedServices);
      await _saveData();
    }
    
    return newService;
  }
  
  // Add hour log to a service
  Future<HourLog> addHourLog(String serviceId, String type) async {
    final newLog = HourLog(
      id: _uuid.v4(),
      serviceId: serviceId,
      type: type,
      startTime: DateTime.now(),
      endTime: null, // Timer is running
    );
    
    for (int i = 0; i < _serviceOrders.length; i++) {
      final order = _serviceOrders[i];
      for (int j = 0; j < order.services.length; j++) {
        final service = order.services[j];
        if (service.id == serviceId && !service.isCompleted) {
          final updatedLogs = [...service.hourLogs, newLog];
          final updatedService = service.copyWith(hourLogs: updatedLogs);
          
          final updatedServices = [...order.services];
          updatedServices[j] = updatedService;
          
          _serviceOrders[i] = order.copyWith(services: updatedServices);
          await _saveData();
          return newLog;
        }
      }
    }
    
    throw Exception('Service not found or is already completed');
  }
  
  // End a running hour log timer
  Future<HourLog> endHourLog(String logId) async {
    HourLog? updatedLog;
    
    for (int i = 0; i < _serviceOrders.length; i++) {
      final order = _serviceOrders[i];
      List<Service> updatedServices = [];
      bool orderUpdated = false;
      
      for (int j = 0; j < order.services.length; j++) {
        final service = order.services[j];
        List<HourLog> updatedLogs = [];
        bool serviceUpdated = false;
        
        for (int k = 0; k < service.hourLogs.length; k++) {
          final log = service.hourLogs[k];
          if (log.id == logId && log.isRunning) {
            updatedLog = log.copyWith(endTime: DateTime.now());
            updatedLogs.add(updatedLog);
            serviceUpdated = true;
          } else {
            updatedLogs.add(log);
          }
        }
        
        if (serviceUpdated) {
          updatedServices.add(service.copyWith(hourLogs: updatedLogs));
          orderUpdated = true;
        } else {
          updatedServices.add(service);
        }
      }
      
      if (orderUpdated) {
        _serviceOrders[i] = order.copyWith(services: updatedServices);
      }
    }
    
    await _saveData();
    if (updatedLog == null) {
      throw Exception('Hour log not found or not running');
    }
    return updatedLog;
  }
  
  // Delete an hour log
  Future<void> deleteHourLog(String logId) async {
    for (int i = 0; i < _serviceOrders.length; i++) {
      final order = _serviceOrders[i];
      List<Service> updatedServices = [];
      bool orderUpdated = false;
      
      for (int j = 0; j < order.services.length; j++) {
        final service = order.services[j];
        if (!service.isCompleted) {
          final updatedLogs = service.hourLogs.where((log) => log.id != logId).toList();
          
          if (updatedLogs.length != service.hourLogs.length) {
            updatedServices.add(service.copyWith(hourLogs: updatedLogs));
            orderUpdated = true;
          } else {
            updatedServices.add(service);
          }
        } else {
          updatedServices.add(service);
        }
      }
      
      if (orderUpdated) {
        _serviceOrders[i] = order.copyWith(services: updatedServices);
      }
    }
    
    await _saveData();
  }
  
  // Delete all hour logs for a service
  Future<void> deleteAllHourLogs(String serviceId) async {
    for (int i = 0; i < _serviceOrders.length; i++) {
      final order = _serviceOrders[i];
      List<Service> updatedServices = [];
      bool orderUpdated = false;
      
      for (int j = 0; j < order.services.length; j++) {
        final service = order.services[j];
        if (service.id == serviceId && !service.isCompleted) {
          updatedServices.add(service.copyWith(hourLogs: []));
          orderUpdated = true;
        } else {
          updatedServices.add(service);
        }
      }
      
      if (orderUpdated) {
        _serviceOrders[i] = order.copyWith(services: updatedServices);
      }
    }
    
    await _saveData();
  }
  
  // Complete a service (finalize it so it can't be edited)
  Future<void> completeService(String serviceId) async {
    for (int i = 0; i < _serviceOrders.length; i++) {
      final order = _serviceOrders[i];
      List<Service> updatedServices = [];
      bool orderUpdated = false;
      
      for (int j = 0; j < order.services.length; j++) {
        final service = order.services[j];
        if (service.id == serviceId && !service.isCompleted) {
          // Check if at least one hour log exists
          if (service.hourLogs.isEmpty) {
            throw Exception('Service must have at least one hour log to be completed');
          }
          
          updatedServices.add(service.copyWith(
            isCompleted: true,
            status: 'completed',
          ));
          orderUpdated = true;
        } else {
          updatedServices.add(service);
        }
      }
      
      if (orderUpdated) {
        final allCompleted = updatedServices.every((s) => s.isCompleted);
        _serviceOrders[i] = order.copyWith(
          services: updatedServices,
          status: allCompleted ? 'completed' : order.status,
        );
      }
    }
    
    await _saveData();
  }
  
  // Update service order status
  Future<void> updateServiceOrderStatus(String orderId, String status) async {
    final orderIndex = _serviceOrders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      _serviceOrders[orderIndex] = _serviceOrders[orderIndex].copyWith(status: status);
      await _saveData();
    }
  }
}
