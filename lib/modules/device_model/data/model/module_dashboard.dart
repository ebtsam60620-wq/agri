import 'package:agri/modules/crop_cycle/data/models/crop_cycle.dart';
import 'package:agri/modules/device_model/data/model/device_module.dart';
import 'package:agri/modules/device_model/data/model/module_reading.dart';
import 'package:agri/modules/device_model/data/model/sensor_status.dart';
import 'package:agri/modules/device_model/data/model/ai_analysis.dart';

class ModuleDashboard {
  final DeviceModule module;
  final ModuleReading? latestReading;
  final List<SensorStatus> sensors;
  final AiAnalysis? lastAiAnalysis;
  final CropCycle? activeCropCycle;

  ModuleDashboard({
    required this.module,
    this.latestReading,
    required this.sensors,
    this.lastAiAnalysis,
    this.activeCropCycle,
  });

  factory ModuleDashboard.fromJson(Map<String, dynamic> json) {
    // Parse the sensors list securely
    final sensorsList = (json['sensors'] as List?)?.map((e) {
      return SensorStatus.fromJson(e as Map<String, dynamic>);
    }).toList() ?? [];

    return ModuleDashboard(
      // Your existing DeviceModule handles the nested location map perfectly
      module: DeviceModule.fromJson(json['module'] as Map<String, dynamic>),
      latestReading: json['latest_reading'] != null 
          ? ModuleReading.fromJson(json['latest_reading'] as Map<String, dynamic>) 
          : null,
      sensors: sensorsList,
      lastAiAnalysis: json['last_ai_analysis'] != null 
          ? AiAnalysis.fromJson(json['last_ai_analysis'] as Map<String, dynamic>) 
          : null,
      activeCropCycle: json['active_crop_cycle'] != null 
          ? CropCycle.fromJson(json['active_crop_cycle'] as Map<String, dynamic>) 
          : null,
    );
  }
}
