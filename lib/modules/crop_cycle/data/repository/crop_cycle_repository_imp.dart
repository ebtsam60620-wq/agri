import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/crop_cycle/data/data_source/crop_cycle_remote_data_source.dart';
import 'package:agri/modules/crop_cycle/data/models/crop_cycle.dart';
import 'package:agri/modules/crop_cycle/domain/repository/crop_cycle_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CropCycleRepository)
class CropCycleRepositoryImp implements CropCycleRepository {
  CropCycleRepositoryImp(this.remoteDataSource);

  final CropCycleRemoteDataSource remoteDataSource;

  @override
  Future<Option<Failure, CropCycle>> createCropCycle({
    required int moduleId,
    required String cycleName,
    required String cropName,
    double? growingAreaM2,
    required DateTime sowingDate,
    DateTime? expectedHarvestDate,
  }) async {
    final result = await remoteDataSource.createCropCycle(
      moduleId: moduleId,
      cycleName: cycleName,
      cropName: cropName,
      growingAreaM2: growingAreaM2,
      sowingDate: sowingDate,
      expectedHarvestDate: expectedHarvestDate,
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => CropCycle.fromJson(r.data));
    });
  }

  @override
  Future<Option<Failure, List<CropCycle>>> listCropCycles(int moduleId) async {
    final result = await remoteDataSource.listCropCycles(moduleId);
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() {
        final list = (r.data ?? []) as List;
        return list.map((e) => CropCycle.fromJson(e)).toList();
      });
    });
  }

  @override
  Future<Option<Failure, CropCycle>> getCropCycle(int cycleId) async {
    final result = await remoteDataSource.getCropCycle(cycleId);
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => CropCycle.fromJson(r.data));
    });
  }

  @override
  Future<Option<Failure, CropCycle>> updateCropCycle({
    required int cycleId,
    String? cycleName,
    String? cropName,
    double? growingAreaM2,
    DateTime? sowingDate,
    DateTime? expectedHarvestDate,
    String? status,
  }) async {
    final result = await remoteDataSource.updateCropCycle(
      cycleId: cycleId,
      cycleName: cycleName,
      cropName: cropName,
      growingAreaM2: growingAreaM2,
      sowingDate: sowingDate,
      expectedHarvestDate: expectedHarvestDate,
      status: status,
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => CropCycle.fromJson(r.data));
    });
  }

  @override
  Future<Option<Failure, CropCycle>> deleteCropCycle(int cycleId) async {
    final result = await remoteDataSource.deleteCropCycle(cycleId);
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => CropCycle.fromJson(r.data));
    });
  }
}
