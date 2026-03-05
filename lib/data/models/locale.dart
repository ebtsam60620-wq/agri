import 'package:objectbox/objectbox.dart';

@Entity()
class LocaleModel {
  @Id()
  int storageID = 0;
  final String languageCode;
  final bool isFirstTime;
  LocaleModel({
    required this.languageCode,
    this.isFirstTime = true,
  });
}
