import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/device_model/data/model/device_module.dart';
import 'package:agri/modules/device_model/domain/repository/device_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'device_state.dart';

class DeviceController extends AutoDisposeNotifier<DeviceState> {
  DeviceController(this._repo);

  late final DeviceModuleRepository _repo;

  @override
  DeviceState build() => DeviceState();

  // --- Internal Helpers ---

  void _setLoading(int? id, bool isLoading) {
    if (id == null) return;
    final newSet = Set<int>.from(state.loadingIds);
    isLoading ? newSet.add(id) : newSet.remove(id);
    state = state.copyWith(loadingIds: newSet);
  }

  // --- Repository Methods ---

  Future<void> linkModule({required String code, String? nickname}) async {
    state = state.copyWith(
      status: Requestenum.loading,
      flow: DeviceFlow.linkingModule,
    );
    final result = await _repo.linkModule(moduleCode: code, nickname: nickname);

    result.fold(
      (f) => state = state.copyWith(
        status: Requestenum.error,
        errorMessage: f.message,
      ),
      (s) => fetchModules(),
    );
  }

  Future<void> fetchModules({bool fromLocal = false}) async {
    state = state.copyWith(
      status: Requestenum.loading,
      flow: DeviceFlow.loadModules,
    );
    final result = await _repo.getMyModules(fromLocal: fromLocal);

    result.fold(
      (f) => state = state.copyWith(status: Requestenum.error),
      (list) =>
          state = state.copyWith(status: Requestenum.success, devices: list),
    );
  }

  Future<void> updateModule(int? id, {String? nickname}) async {
    if (id == null) return;
    // a grude to prevent double click
    if (state.loadingIds.contains(id)) {
      return;
    }
    _setLoading(id, true);
    final result = await _repo.updateModule(moduleId: id, nickname: nickname);

    result.fold(
      (f) => state = state.copyWith(errorMessage: f.message),
      (updated) => state = state.copyWith(
        devices: state.devices
            .map((d) => d.moduleID == id ? updated : d)
            .toList(),
      ),
    );
    _setLoading(id, false);
  }

  Future<void> rotateToken(int? id) async {
    if (id == null) return;
    _setLoading(id, true);
    await _repo.rotateDeviceToken(id);
    // Handle result (e.g., show success snackbar via UI listener)
    _setLoading(id, false);
  }

  Future<void> getDashboardData(int? id) async {
    if (id == null) return;
    _setLoading(id, true);
    await _repo.getModuleDashboard(id);
    // You would likely update a specific ModuleDashboard field in state here
    _setLoading(id, false);
  }

  Future<void> getReadings(int? id, {DateTime? from, DateTime? to}) async {
    if (id == null) return;
    _setLoading(id, true);
    await _repo.getReadings(moduleId: id, from: from, to: to);
    _setLoading(id, false);
  }

  Future<void> fetchAutomationEvents(int? id) async {
    if (id == null) return;
    _setLoading(id, true);
    await _repo.getAutomationEvents(moduleId: id, limit: state.automationLimit);
    _setLoading(id, false);
  }

  // --- UI Helpers ---

  bool isIdLoading(int? id) => state.loadingIds.contains(id);

  void updateLimit(int newLimit) {
    state = state.copyWith(automationLimit: newLimit);
  }
}
