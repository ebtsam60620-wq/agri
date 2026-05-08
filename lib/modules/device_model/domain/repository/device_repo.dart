import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/device_model/data/model/automation_event.dart';
import 'package:agri/modules/device_model/data/model/device_module.dart';
import 'package:agri/modules/device_model/data/model/live_token_response.dart';
import 'package:agri/modules/device_model/data/model/module_dashboard.dart';
import 'package:agri/modules/device_model/data/model/module_overview.dart';
import 'package:agri/modules/device_model/data/model/module_reading.dart';
import 'package:agri/modules/device_model/data/model/sensor_status.dart'; // Or your custom Option/Either wrapper

abstract class DeviceModuleRepository {
  // 1. Module Registration & Linking
  Future<Option<Failure, bool>> linkModule({
    required String moduleCode,
    String? nickname,
  });
  Future<Option<Failure, bool>> linkModuleFromScan({
    required String scanValue,
    String? nickname,
  });

  /// Fetches modules. Syncs with local database for offline support.
  Future<Option<Failure, List<DeviceModule>>> getMyModules({bool fromLocal});

  // 2. Module Configuration & Actions
  /// Updates a module and syncs the changes locally.
  Future<Option<Failure, DeviceModule>> updateModule({
    required int moduleId,
    String? nickname,
    double? locationLat,
    double? locationLng,
    double? tankEmptyDistanceCm,
    double? tankFullDistanceCm,
  });

  Future<Option<Failure, String>> rotateDeviceToken(int moduleId);

  Future<Option<Failure, LiveTokenResponse>> getLiveToken(int moduleId);

  // Monitoring & Data
  Future<Option<Failure, ModuleOverview>> getModuleOverview(int moduleId);

  Future<Option<Failure, ModuleDashboard>> getModuleDashboard(int moduleId);

  Future<Option<Failure, ModuleReading?>> getLatestReading(int moduleId);

  Future<Option<Failure, List<ModuleReading>>> getReadings({
    required int moduleId,
    DateTime? from,
    DateTime? to,
  });

  Future<Option<Failure, List<SensorStatus>>> getSensors(int moduleId);

  Future<Option<Failure, List<AutomationEvent>>> getAutomationEvents({
    required int moduleId,
    int limit = 100,
  });
}
