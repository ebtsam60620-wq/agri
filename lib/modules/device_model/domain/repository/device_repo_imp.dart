// ignore_for_file: strict_top_level_inference

import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/device_model/data/data_source/device_local_data_source.dart';
import 'package:agri/modules/device_model/data/data_source/model_data_source.dart';
import 'package:agri/modules/device_model/data/model/module_dashboard.dart';
import 'package:agri/modules/device_model/data/model/module_overview.dart';
import 'package:agri/modules/device_model/domain/repository/device_repo.dart';
import 'package:injectable/injectable.dart';

// Models
import 'package:agri/modules/device_model/data/model/device_module.dart';
import 'package:agri/modules/device_model/data/model/live_token_response.dart';
import 'package:agri/modules/device_model/data/model/automation_event.dart';
import 'package:agri/modules/device_model/data/model/module_reading.dart';
import 'package:agri/modules/device_model/data/model/sensor_status.dart';

@LazySingleton(as: DeviceModuleRepository)
class DeviceModuleRepositoryImpl implements DeviceModuleRepository {
  final DeviceModuleRemoteDataSource remoteDataSource;
  final DeviceModuleLocalDataSource localDataSource;

  DeviceModuleRepositoryImpl(this.remoteDataSource, this.localDataSource);

  // ---------------------------------------------------------------------------
  // 1. Module Registration & Linking
  // ---------------------------------------------------------------------------

  @override
  Future<Option<Failure, bool>> linkModule({
    required String moduleCode,
    String? nickname,
  }) async {
    return await remoteDataSource.linkModule(
      moduleCode: moduleCode,
      nickname: nickname,
    );
  }

  @override
  Future<Option<Failure, bool>> linkModuleFromScan({
    required String scanValue,
    String? nickname,
  }) async {
    return await remoteDataSource.linkModuleFromScan(
      scanValue: scanValue,
      nickname: nickname,
    );
  }

  @override
  Future<Option<Failure, List<DeviceModule>>> getMyModules({
    bool fromLocal = false,
  }) async {
    if (fromLocal) {
      final localData = await localDataSource.getAllModules();

      if (localData.isNotEmpty) {
        return Right<Failure, List<DeviceModule>>(localData);
      }
    }

    final remoteResult = await remoteDataSource.getMyModules();

    if (remoteResult.isRight) {
      final remoteData = remoteResult.right!;

      await localDataSource.clearAllModules();
      await localDataSource.saveModules(remoteData);

      return remoteResult;
    } else {
      final localData = await localDataSource.getAllModules();

      if (localData.isNotEmpty) {
        return Right<Failure, List<DeviceModule>>(localData);
      }

      return remoteResult;
    }
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
    final remoteResult = await remoteDataSource.updateModule(
      moduleId: moduleId,
      nickname: nickname,
      locationLat: locationLat,
      locationLng: locationLng,
      tankEmptyDistanceCm: tankEmptyDistanceCm,
      tankFullDistanceCm: tankFullDistanceCm,
    );

    if (remoteResult.isRight) {
      final updatedModule = remoteResult.right!;
      await localDataSource.saveModule(updatedModule);
      return remoteResult;
    } else {
      return remoteResult;
    }
  }

  @override
  Future<Option<Failure, String>> rotateDeviceToken(int moduleId) {
    return remoteDataSource.rotateDeviceToken(moduleId);
  }

  @override
  Future<Option<Failure, LiveTokenResponse>> getLiveToken(int moduleId) async {
    final result = await remoteDataSource.getLiveToken(moduleId);
    if (result.isRight) {
      final model = ModelParser.parse(
        () => LiveTokenResponse.fromJson(result.right!),
      );
      return Right(model);
    }
    return Left<Failure, LiveTokenResponse>(result.left!);
  }

  // ---------------------------------------------------------------------------
  // 3. Monitoring & Data
  // ---------------------------------------------------------------------------

  @override
  Future<Option<Failure, ModuleOverview>> getModuleOverview(
    int moduleId,
  ) async {
    final result = await remoteDataSource.getModuleOverview(moduleId);
    if (result.isRight) {
      final model = ModelParser.parse(
        () => ModuleOverview.fromJson(result.right!),
      );
      return Right(model);
    }
    return Left<Failure, ModuleOverview>(result.left!);
  }

  @override
  Future<Option<Failure, ModuleDashboard>> getModuleDashboard(
    int moduleId,
  ) async {
    final result = await remoteDataSource.getModuleDashboard(moduleId);
    if (result.isRight) {
      final model = ModelParser.parse(
        () => ModuleDashboard.fromJson(result.right!),
      );
      return Right(model);
    }
    return Left<Failure, ModuleDashboard>(result.left!);
  }

  @override
  Future<Option<Failure, ModuleReading?>> getLatestReading(int moduleId) async {
    final result = await remoteDataSource.getLatestReading(moduleId);
    if (result.isRight) {
      final model = ModelParser.parse(() {
        final data = result.right!;
        if (data.isEmpty) return null;
        return ModuleReading.fromJson(data);
      });
      return Right(model);
    }
    return Left<Failure, ModuleReading?>(result.left!);
  }

  @override
  Future<Option<Failure, List<ModuleReading>>> getReadings({
    required int moduleId,
    DateTime? from,
    DateTime? to,
  }) async {
    final result = await remoteDataSource.getReadings(
      moduleId: moduleId,
      from: from,
      to: to,
    );

    if (result.isRight) {
      final model = ModelParser.parse(() {
        final list = result.right!;
        return list.map((e) => ModuleReading.fromJson(e)).toList();
      });
      return Right(model);
    }
    return Left<Failure, List<ModuleReading>>(result.left!);
  }

  @override
  Future<Option<Failure, List<SensorStatus>>> getSensors(int moduleId) async {
    final result = await remoteDataSource.getSensors(moduleId);
    if (result.isRight) {
      final model = ModelParser.parse(() {
        final list = result.right!;
        return list.map((e) => SensorStatus.fromJson(e)).toList();
      });
      return Right(model);
    }
    return Left<Failure, List<SensorStatus>>(result.left!);
  }

  @override
  Future<Option<Failure, List<AutomationEvent>>> getAutomationEvents({
    required int moduleId,
    int limit = 100,
  }) async {
    final result = await remoteDataSource.getAutomationEvents(
      moduleId: moduleId,
      limit: limit,
    );

    if (result.isRight) {
      final model = ModelParser.parse(() {
        final list = result.right!;
        return list.map((e) => AutomationEvent.fromJson(e)).toList();
      });
      return Right(model);
    }
    return Left<Failure, List<AutomationEvent>>(result.left!);
  }
}
