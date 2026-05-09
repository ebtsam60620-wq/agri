import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/notification/data/data_source/notification_remote_data_source.dart';
import 'package:agri/modules/notification/domain/repository/notification_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImp implements NotificationRepository {
  NotificationRepositoryImp(this.remoteDataSource);

  final NotificationRemoteDataSource remoteDataSource;

  @override
  Future<Option<Failure, List<Map<String, dynamic>>>> getActiveAlerts(int moduleId) async {
    final result = await remoteDataSource.getActiveAlerts(moduleId);
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() {
        final list = (r.data['items'] ?? []) as List;
        return list.map((e) => e as Map<String, dynamic>).toList();
      });
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> getModuleNotifications({
    required int moduleId,
    String? category,
    String? status,
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    final result = await remoteDataSource.getModuleNotifications(
      moduleId: moduleId,
      category: category,
      status: status,
      search: search,
      page: page,
      perPage: perPage,
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> markNotificationRead(int notificationId) async {
    final result = await remoteDataSource.markNotificationRead(notificationId);
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, int>> markAllNotificationsRead(int moduleId) async {
    final result = await remoteDataSource.markAllNotificationsRead(moduleId);
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data['updated'] as int? ?? 0);
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> registerPushToken({
    required String platform,
    required String pushToken,
  }) async {
    final result = await remoteDataSource.registerPushToken(
      platform: platform,
      pushToken: pushToken,
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, int>> getUnreadCount(int moduleId) async {
    final result = await remoteDataSource.getUnreadCount(moduleId);
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data['unread_count'] as int? ?? 0);
    });
  }
}
