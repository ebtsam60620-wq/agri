class NotificationModel {
  final int id;
  final int userId;
  final int moduleId;
  final String? moduleCode;
  final String? moduleNickname;
  final String category;
  final String type;
  final String severity;
  final String title;
  final String body;
  final String? shortValue;
  final String status;
  final bool isRead;
  final bool isPushSent;
  final Map<String, dynamic>? metadata;
  final int? relatedAnalysisId;
  final int? relatedCropCycleId;
  final int? relatedAutomationEventId;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.moduleId,
    this.moduleCode,
    this.moduleNickname,
    required this.category,
    required this.type,
    required this.severity,
    required this.title,
    required this.body,
    this.shortValue,
    required this.status,
    required this.isRead,
    required this.isPushSent,
    this.metadata,
    this.relatedAnalysisId,
    this.relatedCropCycleId,
    this.relatedAutomationEventId,
    this.createdAt,
    this.resolvedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      moduleId: json['module_id'],
      moduleCode: json['module_code'],
      moduleNickname: json['module_nickname'],
      category: json['category'],
      type: json['type'],
      severity: json['severity'],
      title: json['title'],
      body: json['body'],
      shortValue: json['short_value'],
      status: json['status'],
      isRead: json['is_read'] ?? false,
      isPushSent: json['is_push_sent'] ?? false,
      metadata: json['metadata'],
      relatedAnalysisId: json['related_analysis_id'],
      relatedCropCycleId: json['related_crop_cycle_id'],
      relatedAutomationEventId: json['related_automation_event_id'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      resolvedAt: json['resolved_at'] != null ? DateTime.tryParse(json['resolved_at']) : null,
    );
  }

  bool get isCritical => severity == 'critical' || severity == 'warning';
}
