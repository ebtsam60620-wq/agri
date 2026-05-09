import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/modules/notification/data/data_source/notification_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImp implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImp(this.httpInterface);

  late final HttpDataSource httpInterface;

  @override
  Future<Option<Failure, ResponseAdapter>> getActiveAlerts(int moduleId) async {
    final result = await httpInterface.get(
      url: '/modules/$moduleId/alerts/active',
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> getModuleNotifications({
    required int moduleId,
    String? category,
    String? status,
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'per_page': perPage,
    };
    if (category != null) queryParams['category'] = category;
    if (status != null) queryParams['status'] = status;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final result = await httpInterface.get(
      url: '/modules/$moduleId/notifications',
      queryParameters: queryParams,
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> markNotificationRead(int notificationId) async {
    final result = await httpInterface.post(
      url: '/notifications/$notificationId/read',
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> markAllNotificationsRead(int moduleId) async {
    final result = await httpInterface.post(
      url: '/modules/$moduleId/notifications/read-all',
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> registerPushToken({
    required String platform,
    required String pushToken,
  }) async {
    final result = await httpInterface.post(
      url: '/devices/push-token',
      data: {
        'platform': platform,
        'push_token': pushToken,
      },
    );
    return result.fold((l) => l, (r) => r);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> getUnreadCount(int moduleId) async {
    final result = await httpInterface.get(
      url: '/modules/$moduleId/notifications/unread-count',
    );
    return result.fold((l) => l, (r) => r);
  }
}
