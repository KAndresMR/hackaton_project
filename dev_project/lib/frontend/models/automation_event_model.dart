class AutomationEventModel {
  const AutomationEventModel({
    required this.id,
    required this.action,
    required this.status,
    required this.timestamp,
  });

  final int id;
  final String action;
  final String status;
  final DateTime timestamp;

  factory AutomationEventModel.fromJson(Map<String, dynamic> json) {
    return AutomationEventModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      action: json['action']?.toString() ?? 'Event',
      status: json['status']?.toString() ?? 'completed',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
