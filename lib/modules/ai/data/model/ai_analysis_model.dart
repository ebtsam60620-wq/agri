class DiseaseModel {
  final bool detected;
  final String? name;
  final double? confidence;
  final String? treatment;
  final String? model;
  final int occurrenceCount;
  final DateTime? lastSeenAt;

  DiseaseModel({
    required this.detected,
    this.name,
    this.confidence,
    this.treatment,
    this.model,
    required this.occurrenceCount,
    this.lastSeenAt,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      detected: json['detected'] ?? false,
      name: json['name'],
      confidence: json['confidence']?.toDouble(),
      treatment: json['treatment'],
      model: json['model'],
      occurrenceCount: json['occurrence_count'] ?? 1,
      lastSeenAt: json['last_seen_at'] != null ? DateTime.tryParse(json['last_seen_at']) : null,
    );
  }
}

class HarvestModel {
  final double? readiness;
  final String? status;
  final double? confidence;
  final String? model;

  HarvestModel({
    this.readiness,
    this.status,
    this.confidence,
    this.model,
  });

  factory HarvestModel.fromJson(Map<String, dynamic> json) {
    return HarvestModel(
      readiness: json['readiness']?.toDouble(),
      status: json['status'],
      confidence: json['confidence']?.toDouble(),
      model: json['model'],
    );
  }
}

class AiAnalysisModel {
  final int id;
  final int userId;
  final int moduleId;
  final String? moduleCode;
  final String? moduleNickname;
  final String? imageUrl;
  final String? imagePolicyKind;
  final DateTime? imageExpiresAt;
  final DiseaseModel disease;
  final HarvestModel harvest;
  final DateTime? createdAt;
  final DateTime? analyzedAt;

  AiAnalysisModel({
    required this.id,
    required this.userId,
    required this.moduleId,
    this.moduleCode,
    this.moduleNickname,
    this.imageUrl,
    this.imagePolicyKind,
    this.imageExpiresAt,
    required this.disease,
    required this.harvest,
    this.createdAt,
    this.analyzedAt,
  });

  factory AiAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AiAnalysisModel(
      id: json['id'],
      userId: json['user_id'],
      moduleId: json['module_id'],
      moduleCode: json['module_code'],
      moduleNickname: json['module_nickname'],
      imageUrl: json['image_url'],
      imagePolicyKind: json['image_policy_kind'],
      imageExpiresAt: json['image_expires_at'] != null ? DateTime.tryParse(json['image_expires_at']) : null,
      disease: DiseaseModel.fromJson(json['disease'] ?? {}),
      harvest: HarvestModel.fromJson(json['harvest'] ?? {}),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      analyzedAt: json['analyzed_at'] != null ? DateTime.tryParse(json['analyzed_at']) : null,
    );
  }
}
