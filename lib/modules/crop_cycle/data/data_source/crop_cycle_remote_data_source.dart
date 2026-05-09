import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';

abstract class CropCycleRemoteDataSource {
  Future<Option<Failure, ResponseAdapter>> createCropCycle({
    required int moduleId,
    required String cycleName,
    required String cropName,
    double? growingAreaM2,
    required DateTime sowingDate,
    DateTime? expectedHarvestDate,
  });

  Future<Option<Failure, ResponseAdapter>> listCropCycles(int moduleId);

  Future<Option<Failure, ResponseAdapter>> getCropCycle(int cycleId);

  Future<Option<Failure, ResponseAdapter>> updateCropCycle({
    required int cycleId,
    String? cycleName,
    String? cropName,
    double? growingAreaM2,
    DateTime? sowingDate,
    DateTime? expectedHarvestDate,
    String? status,
  });

  Future<Option<Failure, ResponseAdapter>> deleteCropCycle(int cycleId);
}
