import 'package:dreamflow/models/service.dart';

class ServiceOrder {
  final String id;
  final String title;
  final String description;
  final DateTime dateCreated;
  final String status; // pending, in_progress, completed
  final List<Service> services;

  ServiceOrder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateCreated,
    required this.status,
    required this.services,
  });

  ServiceOrder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateCreated,
    String? status,
    List<Service>? services,
  }) {
    return ServiceOrder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
      status: status ?? this.status,
      services: services ?? this.services,
    );
  }

  factory ServiceOrder.fromJson(Map<String, dynamic> json) {
    return ServiceOrder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateCreated: DateTime.parse(json['dateCreated']),
      status: json['status'],
      services: (json['services'] as List<dynamic>)
          .map((serviceJson) => Service.fromJson(serviceJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateCreated': dateCreated.toIso8601String(),
      'status': status,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}
