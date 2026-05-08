class AutomationEvent {
  final int id;
  final int moduleId;
  final String eventType;
  final Map<String, dynamic> details; // Details usually vary heavily, so Map is okay here
  final DateTime? createdAt;

  AutomationEvent({
    required this.id,
    required this.moduleId,
    required this.eventType,
    required this.details,
    this.createdAt,
  });

  factory AutomationEvent.fromJson(Map<String, dynamic> json) {
    return AutomationEvent(
      id: json['id'] as int,
      moduleId: json['module_id'] as int,
      eventType: json['event_type'].toString(),
      details: json['details'] as Map<String, dynamic>? ?? {},
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}