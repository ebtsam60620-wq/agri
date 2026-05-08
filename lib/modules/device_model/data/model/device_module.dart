import 'package:objectbox/objectbox.dart';

@Entity()
class DeviceModule {
  // ObjectBox internal ID. Set to 0 for new objects.
  @Id()
  int storageID = 0;

  // Unique constraint to sync with your Backend ID
  @Unique(onConflict: ConflictStrategy.replace)
  final int moduleID; 

  final String? moduleCode;
  final String? nickname;
  final double? locationLat;
  final double? locationLng;
  final int? updateIntervalSec;

  @Property(type: PropertyType.date)
  final DateTime? lastSeenAt;

  final bool? isActive;
  final String? role;

  DeviceModule({
    this.storageID = 0, // Default to 0 for new records
    required this.moduleID,
    this.moduleCode,
    this.nickname,
    this.locationLat,
    this.locationLng,
    this.updateIntervalSec,
    this.lastSeenAt,
    this.isActive,
    this.role,
  });

  factory DeviceModule.fromJson(Map<String, dynamic> json) {
    // Navigate nested 'data' wrapper if it exists
    final data = json['data'] ?? json;
    final location = data['location'] as Map<String, dynamic>?;
    
    final idValue = data['id'] as int? ?? 0;

    return DeviceModule(
      // We map the API 'id' to our unique moduleID
      moduleID: idValue,
      moduleCode: data['module_code']?.toString(),
      nickname: data['nickname']?.toString(),
      locationLat: location?['lat']?.toDouble(),
      locationLng: location?['lng']?.toDouble(),
      updateIntervalSec: data['update_interval_sec'] as int?,
      lastSeenAt: data['last_seen_at'] != null
          ? DateTime.tryParse(data['last_seen_at'].toString())
          : null,
      isActive: data['is_active'] as bool?,
      role: data['role']?.toString(),
    );
  }

  DeviceModule copyWith({
    int? storageID,
    int? moduleID,
    String? moduleCode,
    String? nickname,
    double? locationLat,
    double? locationLng,
    int? updateIntervalSec,
    DateTime? lastSeenAt,
    bool? isActive,
    String? role,
  }) {
    return DeviceModule(
      storageID: storageID ?? this.storageID,
      moduleID: moduleID ?? this.moduleID,
      moduleCode: moduleCode ?? this.moduleCode,
      nickname: nickname ?? this.nickname,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      updateIntervalSec: updateIntervalSec ?? this.updateIntervalSec,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }

  // Equality and toString remain largely the same, 
  // but consider if storageID should be part of equality.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModule &&
          runtimeType == other.runtimeType &&
          moduleID == other.moduleID &&
          storageID == other.storageID;

  @override
  int get hashCode => moduleID.hashCode ^ storageID.hashCode;
}