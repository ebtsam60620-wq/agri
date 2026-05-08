import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/device_model/data/data_source/model_data_source.dart'; // Where your abstract class is
import 'package:agri/modules/device_model/data/model/device_module.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DeviceModuleRemoteDataSource)
class DeviceModelDataSourceImp implements DeviceModuleRemoteDataSource {
  DeviceModelDataSourceImp(this.httpInterface);

  late final HttpDataSource httpInterface;

  // ---------------------------------------------------------------------------
  // 1. Module Registration & Linking
  // ---------------------------------------------------------------------------

  @override
  Future<Option<Failure, bool>> linkModule({
    required String moduleCode,
    String? nickname,
  }) async {
    final result = await httpInterface.post(
      url: '/modules/link',
      data: {'module_code': moduleCode, 'nickname': ?nickname},
    );
    return result.fold((l) => l, (r) {
      // Returns true if the request was successful
      return ModelParser.parse(() => true);
    });
  }

  @override
  Future<Option<Failure, bool>> linkModuleFromScan({
    required String scanValue,
    String? nickname,
  }) async {
    final result = await httpInterface.post(
      url: '/modules/link/scan',
      data: {'scan_value': scanValue, 'nickname': ?nickname},
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => true);
    });
  }

  @override
  Future<Option<Failure, List<DeviceModule>>> getMyModules() async {
    final result = await httpInterface.get(url: '/modules/my');
    return result.fold((l) => l, (r) {
      // if(r.data)
      return ModelParser.parse(() {
        final dataList = (r.data) as List;
        return dataList.map((e) => DeviceModule.fromJson(e)).toList();
      });
    });
  }

  // ---------------------------------------------------------------------------
  // 2. Module Configuration & Actions
  // ---------------------------------------------------------------------------

  @override
  Future<Option<Failure, DeviceModule>> updateModule({
    required int moduleId,
    String? nickname,
    double? locationLat,
    double? locationLng,
    double? tankEmptyDistanceCm,
    double? tankFullDistanceCm,
  }) async {
    final Map<String, dynamic> body = {};
    if (nickname != null) body['nickname'] = nickname;
    if (locationLat != null) body['location_lat'] = locationLat;
    if (locationLng != null) body['location_lng'] = locationLng;
    if (tankEmptyDistanceCm != null) {
      body['tank_empty_distance_cm'] = tankEmptyDistanceCm;
    }
    if (tankFullDistanceCm != null) {
      body['tank_full_distance_cm'] = tankFullDistanceCm;
    }

    final result = await httpInterface.put(
      url: '/modules/$moduleId',
      data: body,
    );

    return result.fold((l) => l, (r) {
      return ModelParser.parse(
        () => DeviceModule.fromJson(r.data['data'] ?? r.data),
      );
    });
  }

  @override
  Future<Option<Failure, String>> rotateDeviceToken(int moduleId) async {
    final result = await httpInterface.post(
      url: '/modules/$moduleId/device-token/rotate',
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data['new_token'].toString());
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> getLiveToken(
    int moduleId,
  ) async {
    final result = await httpInterface.post(
      url: '/modules/$moduleId/live/token',
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  // ---------------------------------------------------------------------------
  // 3. Monitoring & Data
  // ---------------------------------------------------------------------------

  @override
  Future<Option<Failure, Map<String, dynamic>>> getModuleOverview(
    int moduleId,
  ) async {
    final result = await httpInterface.get(
      url: '/modules/$moduleId/overview',
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> getModuleDashboard(
    int moduleId,
  ) async {
    final result = await httpInterface.get(
      url: '/modules/$moduleId/dashboard',
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> getLatestReading(
    int moduleId,
  ) async {
    final result = await httpInterface.get(url: '/modules/$moduleId/latest');
    return result.fold((l) => l, (r) {
      return ModelParser.parse(
        () => (r.data['latest'] ?? {}) as Map<String, dynamic>,
      );
    });
  }

  @override
  Future<Option<Failure, List<Map<String, dynamic>>>> getReadings({
    required int moduleId,
    DateTime? from,
    DateTime? to,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    final result = await httpInterface.get(
      url: '/modules/$moduleId/readings',
      // Assuming your HttpDataSource supports queryParameters.
      // If it requires it in the URL, you might need to append them manually.
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() {
        final list = (r.data['readings'] ?? []) as List;
        return list.map((e) => e as Map<String, dynamic>).toList();
      });
    });
  }

  @override
  Future<Option<Failure, List<Map<String, dynamic>>>> getSensors(
    int moduleId,
  ) async {
    final result = await httpInterface.get(
      url: '/modules/$moduleId/sensors',
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() {
        final list = (r.data['sensors'] ?? []) as List;
        return list.map((e) => e as Map<String, dynamic>).toList();
      });
    });
  }

  @override
  Future<Option<Failure, List<Map<String, dynamic>>>> getAutomationEvents({
    required int moduleId,
    int limit = 100,
  }) async {
    final result = await httpInterface.get(
      url: '/modules/$moduleId/automation-events',
      queryParameters: {'limit': limit},
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() {
        final list = (r.data['items'] ?? []) as List;
        return list.map((e) => e as Map<String, dynamic>).toList();
      });
    });
  }
}
