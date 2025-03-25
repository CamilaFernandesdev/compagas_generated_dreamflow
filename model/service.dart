import 'package:dreamflow/models/hour_log.dart';

class Service {
  final String id;
  final String serviceOrderId;
  final String title;
  final String description;
  final String status; // pending, in_progress, completed
  final List<HourLog> hourLogs;
  final bool isCompleted;

  Service({
    required this.id,
    required this.serviceOrderId,
    required this.title,
    required this.description,
    required this.status,
    required this.hourLogs,
    required this.isCompleted,
  });

  Service copyWith({
    String? id,
    String? serviceOrderId,
    String? title,
    String? description,
    String? status,
    List<HourLog>? hourLogs,
    bool? isCompleted,
  }) {
    return Service(
      id: id ?? this.id,
      serviceOrderId: serviceOrderId ?? this.serviceOrderId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      hourLogs: hourLogs ?? this.hourLogs,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Duration get totalTime {
    Duration total = Duration.zero;
    for (final log in hourLogs) {
      total += log.totalTime;
    }
    return total;
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      serviceOrderId: json['serviceOrderId'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      hourLogs: (json['hourLogs'] as List<dynamic>)
          .map((logJson) => HourLog.fromJson(logJson))
          .toList(),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceOrderId': serviceOrderId,
      'title': title,
      'description': description,
      'status': status,
      'hourLogs': hourLogs.map((log) => log.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }
}
