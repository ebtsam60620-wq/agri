import 'package:agri/data/data_sources/localization_local_data_source.dart';
import 'package:agri/data/models/locale.dart';
import 'package:injectable/injectable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart';
@LazySingleton(as: LocalizationLocalDataSource)
class LocalizationStorageImpl implements LocalizationLocalDataSource {
  late final Box<LocaleModel> localDataInstance;

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final Store store = await openStore(
      directory: join(dir.path, 'objectbox-localization'),
    );
    localDataInstance = store.box<LocaleModel>();
  }

  @override
  LocaleModel getLocalization() {
    return localDataInstance.getAll().firstOrNull ??
        LocaleModel(languageCode: 'en', isFirstTime: true);
  }

  @override
  void setLocalizationCode(String s) {
    localDataInstance.removeAll();
    localDataInstance.put(
      LocaleModel(
        languageCode: s,
        isFirstTime: false,
      ),
    );
  }
}
