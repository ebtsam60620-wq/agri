// import 'package:agri/objectbox.g.dart'; // IMPORTANT: Import your generated ObjectBox file
import 'package:agri/data/data_sources/objectbox.g.dart';
import 'package:agri/modules/device_model/data/data_source/device_local_data_source.dart';
import 'package:agri/modules/device_model/data/model/device_module.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: DeviceModuleLocalDataSource)
class DeviceModuleLocalDataSourceImpl implements DeviceModuleLocalDataSource {
  late final Box<DeviceModule> _moduleBox;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final Store store = await openStore(
      directory: join(docsDir.path, 'objectbox-device'),
    );
    _moduleBox = store.box<DeviceModule>();
  }

  @override
  Future<void> saveModule(DeviceModule module) async {
    // Because of @Unique(onConflict: ConflictStrategy.replace) on moduleID,
    // this will automatically update an existing module or insert a new one.
    _moduleBox.put(module);
  }

  @override
  Future<void> saveModules(List<DeviceModule> modules) async {
    // putMany is much faster than looping through put() for lists.
    _moduleBox.putMany(modules);
  }

  @override
  Future<List<DeviceModule>> getAllModules() async {
    return _moduleBox.getAll();
  }

  @override
  Future<DeviceModule?> getModuleById(int moduleId) async {
    // We query by the API's `moduleID`, NOT the ObjectBox `storageID`
    final query = _moduleBox
        .query(DeviceModule_.moduleID.equals(moduleId))
        .build();
    final module = query.findFirst();
    query.close(); // Always close queries to prevent memory leaks

    return module;
  }

  @override
  Future<bool> deleteModule(int moduleId) async {
    final query = _moduleBox
        .query(DeviceModule_.moduleID.equals(moduleId))
        .build();
    final module = query.findFirst();

    if (module != null) {
      // ObjectBox requires the local storageID to remove an item
      final removed = _moduleBox.remove(module.moduleID);
      query.close();
      return removed;
    }

    query.close();
    return false; // Module didn't exist locally
  }

  @override
  Future<void> clearAllModules() async {
    _moduleBox.removeAll();
  }
}
