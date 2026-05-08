import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/device_model/data/model/device_module.dart';

abstract class DeviceModuleRemoteDataSource {
  // 1. Module Registration & Linking
  Future<Option<Failure, bool>> linkModule({
    required String moduleCode,
    String? nickname,
  });

  Future<Option<Failure, bool>> linkModuleFromScan({
    required String scanValue,
    String? nickname,
  });

  Future<Option<Failure, List<DeviceModule>>> getMyModules();

  // 2. Module Configuration & Actions
  Future<Option<Failure, DeviceModule>> updateModule({
    required int moduleId,
    String? nickname,
    double? locationLat,
    double? locationLng,
    double? tankEmptyDistanceCm,
    double? tankFullDistanceCm,
  });

  Future<Option<Failure, String>> rotateDeviceToken(int moduleId);

  Future<Option<Failure, Map<String, dynamic>>> getLiveToken(int moduleId);

  // 3. Monitoring & Data
  Future<Option<Failure, Map<String, dynamic>>> getModuleOverview(int moduleId);

  Future<Option<Failure, Map<String, dynamic>>> getModuleDashboard(int moduleId);

  Future<Option<Failure, Map<String, dynamic>>> getLatestReading(int moduleId);

  Future<Option<Failure, List<Map<String, dynamic>>>> getReadings({
    required int moduleId,
    DateTime? from,
    DateTime? to,
  });

  Future<Option<Failure, List<Map<String, dynamic>>>> getSensors(int moduleId);

  Future<Option<Failure, List<Map<String, dynamic>>>> getAutomationEvents({
    required int moduleId,
    int limit = 100,
  });
}