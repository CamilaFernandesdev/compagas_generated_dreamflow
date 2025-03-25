class HourLog {
  final String id;
  final String serviceId;
  final String type; // displacement, waiting, execution
  final DateTime startTime;
  final DateTime? endTime; // Null if timer is still running

  HourLog({
    required this.id,
    required this.serviceId,
    required this.type,
    required this.startTime,
    this.endTime,
  });

  HourLog copyWith({
    String? id,
    String? serviceId,
    String? type,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return HourLog(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  bool get isRunning => endTime == null;

  Duration get totalTime {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  factory HourLog.fromJson(Map<String, dynamic> json) {
    return HourLog(
      id: json['id'],
      serviceId: json['serviceId'],
      type: json['type'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'type': type,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}
