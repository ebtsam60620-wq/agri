import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/device_model/data/model/module_reading.dart';
import 'package:agri/modules/device_model/data/model/sensor_status.dart';
import 'package:agri/modules/device_model/domain/repository/device_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'field_conditions_state.dart';

class FieldConditionsController extends AutoDisposeNotifier<FieldConditionsState> {
  FieldConditionsController(this._repo);

  final DeviceModuleRepository _repo;

  @override
  FieldConditionsState build() => FieldConditionsState();

  Future<void> fetchLatestReading(int moduleId) async {
    state = state.copyWith(systemStatus: Requestenum.loading);

    final result = await _repo.getLatestReading(moduleId);

    result.fold(
      (f) => state = state.copyWith(
        systemStatus: Requestenum.error,
        errorMessage: f.message,
      ),
      (r) => state = state.copyWith(
        systemStatus: Requestenum.success,
        latestReading: r,
      ),
    );
  }

  Future<void> fetchSensors(int moduleId) async {
    state = state.copyWith(sensorStatus: Requestenum.loading);

    final result = await _repo.getSensors(moduleId);

    result.fold(
      (f) => state = state.copyWith(
        sensorStatus: Requestenum.error,
        errorMessage: f.message,
      ),
      (s) => state = state.copyWith(
        sensorStatus: Requestenum.success,
        sensors: s,
      ),
    );
  }

  Future<void> refreshAll(int moduleId) async {
    await Future.wait([
      fetchLatestReading(moduleId),
      fetchSensors(moduleId),
    ]);
  }
}
