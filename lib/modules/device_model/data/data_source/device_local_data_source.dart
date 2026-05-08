import 'package:agri/modules/device_model/data/model/device_module.dart';

abstract class DeviceModuleLocalDataSource {
  /// Saves a single module to the local database.
  Future<void> saveModule(DeviceModule module);

  /// Saves a list of modules (e.g., fetched from the remote API) to the database.
  Future<void> saveModules(List<DeviceModule> modules);

  /// Retrieves all cached modules from the database.
  Future<List<DeviceModule>> getAllModules();

  /// Retrieves a specific module by its remote [moduleID].
  Future<DeviceModule?> getModuleById(int moduleId);

  /// Removes a specific module from the database by its remote [moduleID].
  Future<bool> deleteModule(int moduleId);

  /// Clears all modules from the local database (useful for logout/refresh).
  Future<void> clearAllModules();
}
