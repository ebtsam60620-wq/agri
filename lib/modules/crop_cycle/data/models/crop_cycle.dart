class CropCycle {
  final int id;
  final int userId;
  final int moduleId;
  final String cycleName;
  final String cropName;
  final double? growingAreaM2;
  final DateTime? sowingDate;
  final DateTime? expectedHarvestDate;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CropCycle({
    required this.id,
    required this.userId,
    required this.moduleId,
    required this.cycleName,
    required this.cropName,
    this.growingAreaM2,
    this.sowingDate,
    this.expectedHarvestDate,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CropCycle.fromJson(Map<String, dynamic> json) {
    return CropCycle(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      moduleId: json['module_id'] as int? ?? 0,
      cycleName: json['cycle_name'].toString(),
      cropName: json['crop_name'].toString(),
      growingAreaM2: json['growing_area_m2']?.toDouble(),
      sowingDate: json['sowing_date'] != null 
          ? DateTime.tryParse(json['sowing_date'].toString()) 
          : null,
      expectedHarvestDate: json['expected_harvest_date'] != null 
          ? DateTime.tryParse(json['expected_harvest_date'].toString()) 
          : null,
      status: json['status'].toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) 
          : null,
    );
  }
}