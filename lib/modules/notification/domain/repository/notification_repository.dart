import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';

abstract class NotificationRepository {
  Future<Option<Failure, List<Map<String, dynamic>>>> getActiveAlerts(int moduleId);

  Future<Option<Failure, Map<String, dynamic>>> getModuleNotifications({
    required int moduleId,
    String? category,
    String? status,
    String? search,
    int page = 1,
    int perPage = 20,
  });

  Future<Option<Failure, Map<String, dynamic>>> markNotificationRead(int notificationId);

  Future<Option<Failure, int>> markAllNotificationsRead(int moduleId);

  Future<Option<Failure, Map<String, dynamic>>> registerPushToken({
    required String platform,
    required String pushToken,
  });

  Future<Option<Failure, int>> getUnreadCount(int moduleId);
}
