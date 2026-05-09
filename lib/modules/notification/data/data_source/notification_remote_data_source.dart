import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';

abstract class NotificationRemoteDataSource {
  Future<Option<Failure, ResponseAdapter>> getActiveAlerts(int moduleId);

  Future<Option<Failure, ResponseAdapter>> getModuleNotifications({
    required int moduleId,
    String? category,
    String? status,
    String? search,
    int page = 1,
    int perPage = 20,
  });

  Future<Option<Failure, ResponseAdapter>> markNotificationRead(int notificationId);

  Future<Option<Failure, ResponseAdapter>> markAllNotificationsRead(int moduleId);

  Future<Option<Failure, ResponseAdapter>> registerPushToken({
    required String platform,
    required String pushToken,
  });

  Future<Option<Failure, ResponseAdapter>> getUnreadCount(int moduleId);
}
