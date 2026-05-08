import 'package:agri/modules/device_model/data/model/module_reading.dart';

class ModuleOverview {
  final int id;
  final String moduleCode;
  final String? nickname;
  final double? locationLat;
  final double? locationLng;
  final DateTime? lastSeenAt;
  final int? updateIntervalSec;
  final String status;
  final int activeCropCyclesCount;
  final int irrigationCyclesLast24h;
  final ModuleReading? latestReading;

  ModuleOverview({
    required this.id,
    required this.moduleCode,
    this.nickname,
    this.locationLat,
    this.locationLng,
    this.lastSeenAt,
    this.updateIntervalSec,
    required this.status,
    required this.activeCropCyclesCount,
    required this.irrigationCyclesLast24h,
    this.latestReading,
  });

  factory ModuleOverview.fromJson(Map<String, dynamic> json) {
    return ModuleOverview(
      id: json['id'] as int? ?? 0,
      moduleCode: json['module_code'].toString(),
      nickname: json['nickname']?.toString(),
      locationLat: json['location_lat']?.toDouble(),
      locationLng: json['location_lng']?.toDouble(),
      lastSeenAt: json['last_seen_at'] != null 
          ? DateTime.tryParse(json['last_seen_at'].toString()) 
          : null,
      updateIntervalSec: json['update_interval_sec'] as int?,
      status: json['status']?.toString() ?? 'inactive',
      activeCropCyclesCount: json['active_crop_cycles_count'] as int? ?? 0,
      irrigationCyclesLast24h: json['irrigation_cycles_last_24h'] as int? ?? 0,
      latestReading: json['latest_reading'] != null 
          ? ModuleReading.fromJson(json['latest_reading'] as Map<String, dynamic>) 
          : null,
    );
  }
}