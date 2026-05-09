import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/crop_cycle/data/models/crop_cycle.dart';

abstract class CropCycleRepository {
  Future<Option<Failure, CropCycle>> createCropCycle({
    required int moduleId,
    required String cycleName,
    required String cropName,
    double? growingAreaM2,
    required DateTime sowingDate,
    DateTime? expectedHarvestDate,
  });

  Future<Option<Failure, List<CropCycle>>> listCropCycles(int moduleId);

  Future<Option<Failure, CropCycle>> getCropCycle(int cycleId);

  Future<Option<Failure, CropCycle>> updateCropCycle({
    required int cycleId,
    String? cycleName,
    String? cropName,
    double? growingAreaM2,
    DateTime? sowingDate,
    DateTime? expectedHarvestDate,
    String? status,
  });

  Future<Option<Failure, CropCycle>> deleteCropCycle(int cycleId);
}
