import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/crop_cycle/data/models/crop_cycle.dart';
import 'package:agri/modules/crop_cycle/domain/repository/crop_cycle_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'crop_cycle_state.dart';

class CropCycleController extends AutoDisposeNotifier<CropCycleState> {
  CropCycleController(this._repo);

  late final CropCycleRepository _repo;

  @override
  CropCycleState build() => CropCycleState();

  Future<void> fetchCropCycles(int moduleId) async {
    state = state.copyWith(status: Requestenum.loading);
    final result = await _repo.listCropCycles(moduleId);

    result.fold(
      (f) => state = state.copyWith(
        status: Requestenum.error,
        errorMessage: f.message,
      ),
      (list) => state = state.copyWith(
        status: Requestenum.success,
        cropCycles: list,
      ),
    );
  }

  Future<void> createCropCycle({
    required int moduleId,
    required String cycleName,
    required String cropName,
    double? growingAreaM2,
    required DateTime sowingDate,
    DateTime? expectedHarvestDate,
  }) async {
    state = state.copyWith(addStatus: Requestenum.loading);
    final result = await _repo.createCropCycle(
      moduleId: moduleId,
      cycleName: cycleName,
      cropName: cropName,
      growingAreaM2: growingAreaM2,
      sowingDate: sowingDate,
      expectedHarvestDate: expectedHarvestDate,
    );

    result.fold(
      (f) => state = state.copyWith(
        addStatus: Requestenum.error,
        errorMessage: f.message,
      ),
      (cycle) {
        state = state.copyWith(
          addStatus: Requestenum.success,
          cropCycles: [...state.cropCycles, cycle],
        );
      },
    );
  }

  Future<void> updateCropCycle({
    required int cycleId,
    String? cycleName,
    String? cropName,
    double? growingAreaM2,
    DateTime? sowingDate,
    DateTime? expectedHarvestDate,
    String? status,
  }) async {
    state = state.copyWith(updateStatus: Requestenum.loading);
    final result = await _repo.updateCropCycle(
      cycleId: cycleId,
      cycleName: cycleName,
      cropName: cropName,
      growingAreaM2: growingAreaM2,
      sowingDate: sowingDate,
      expectedHarvestDate: expectedHarvestDate,
      status: status,
    );

    result.fold(
      (f) => state = state.copyWith(
        updateStatus: Requestenum.error,
        errorMessage: f.message,
      ),
      (cycle) {
        state = state.copyWith(
          updateStatus: Requestenum.success,
          cropCycles: state.cropCycles.map((c) => c.id == cycleId ? cycle : c).toList(),
        );
      },
    );
  }

  Future<void> deleteCropCycle(int cycleId) async {
    state = state.copyWith(deleteStatus: Requestenum.loading);
    final result = await _repo.deleteCropCycle(cycleId);

    result.fold(
      (f) => state = state.copyWith(
        deleteStatus: Requestenum.error,
        errorMessage: f.message,
      ),
      (_) {
        state = state.copyWith(
          deleteStatus: Requestenum.success,
          cropCycles: state.cropCycles.where((c) => c.id != cycleId).toList(),
        );
      },
    );
  }
}
