
import 'package:agri/data/models/locale.dart';

abstract class LocalizationLocalDataSource {
  Future<void> init();

  LocaleModel getLocalization();

  void setLocalizationCode(String s);
}
