import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/modules/crop_cycle/data/data_source/crop_cycle_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CropCycleRemoteDataSource)
class CropCycleRemoteDataSourceImp implements CropCycleRemoteDataSource {
  CropCycleRemoteDataSourceImp(this.httpInterface);

  late final HttpDataSource httpInterface;

  @override
  Future<Option<Failure, ResponseAdapter>> createCropCycle({
    required int moduleId,
    required String cycleName,
    required String cropName,
    double? growingAreaM2,
    required DateTime sowingDate,
    DateTime? expectedHarvestDate,
  }) async {
    final Map<String, dynamic> body = {
      'module_id': moduleId,
      'cycle_name': cycleName,
      'crop_name': cropName,
      'sowing_date': sowingDate.toIso8601String().split('T')[0],
    };
    if (growingAreaM2 != null) body['growing_area_m2'] = growingAreaM2;
    if (expectedHarvestDate != null) {
      body['expected_harvest_date'] = expectedHarvestDate.toIso8601String().split('T')[0];
    }

    final result = await httpInterface.post(
      url: '/modules/crop-cycles',
      data: body,
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> listCropCycles(int moduleId) async {
    final result = await httpInterface.get(
      url: '/modules/$moduleId/crop-cycles',
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> getCropCycle(int cycleId) async {
    final result = await httpInterface.get(
      url: '/modules/crop-cycles/$cycleId',
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> updateCropCycle({
    required int cycleId,
    String? cycleName,
    String? cropName,
    double? growingAreaM2,
    DateTime? sowingDate,
    DateTime? expectedHarvestDate,
    String? status,
  }) async {
    final Map<String, dynamic> body = {};
    if (cycleName != null) body['cycle_name'] = cycleName;
    if (cropName != null) body['crop_name'] = cropName;
    if (growingAreaM2 != null) body['growing_area_m2'] = growingAreaM2;
    if (sowingDate != null) {
      body['sowing_date'] = sowingDate.toIso8601String().split('T')[0];
    }
    if (expectedHarvestDate != null) {
      body['expected_harvest_date'] = expectedHarvestDate.toIso8601String().split('T')[0];
    }
    if (status != null) body['status'] = status;

    final result = await httpInterface.put(
      url: '/modules/crop-cycles/$cycleId',
      data: body,
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> deleteCropCycle(int cycleId) async {
    final result = await httpInterface.delete(
      url: '/modules/crop-cycles/$cycleId',
    );
    return result.fold((l) => l, (r) => r);
  }
}
