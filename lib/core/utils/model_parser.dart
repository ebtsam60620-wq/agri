import 'dart:developer';

class ModelParser {
  ModelParser._();

  static T parse<T>(T Function() parseFunction) {
    try {
      return parseFunction();
    } catch (e, stacktrace) {
      log(e.toString(), error: e, stackTrace: stacktrace);

      throw e.toString().replaceAll('Exception:', '');
    }
  }
}
