import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/notification/data/model/notification_model.dart';
import 'package:agri/modules/notification/domain/repository/notification_repository.dart';
import 'package:agri/modules/notification/presentation/controller/notification_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationController extends AutoDisposeNotifier<NotificationState> {
  NotificationController(this._repository);

  final NotificationRepository _repository;

  @override
  NotificationState build() => NotificationState();

  Future<void> fetchAlerts(int moduleId) async {
    state = state.copyWith(status: Requestenum.loading);
    final result = await _repository.getActiveAlerts(moduleId);

    result.fold(
      (failure) => state = state.copyWith(
        status: Requestenum.error,
        errorMessage: failure.message,
      ),
      (alerts) => state = state.copyWith(
        status: Requestenum.success,
        alerts: alerts.map((e) => NotificationModel.fromJson(e)).toList(),
      ),
    );
  }

  Future<void> fetchNotifications(int moduleId) async {
    state = state.copyWith(status: Requestenum.loading);
    final result = await _repository.getModuleNotifications(moduleId: moduleId);

    result.fold(
      (failure) => state = state.copyWith(
        status: Requestenum.error,
        errorMessage: failure.message,
      ),
      (data) {
        final List items = (data['items'] ?? []) as List;
        state = state.copyWith(
          status: Requestenum.success,
          notifications: items.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList(),
        );
      },
    );
  }

  Future<void> fetchUnreadCount(int moduleId) async {
    final result = await _repository.getUnreadCount(moduleId);
    result.fold(
      (failure) => null,
      (count) => state = state.copyWith(unreadCount: count),
    );
  }

  Future<void> markAsRead(int notificationId, int moduleId) async {
    await _repository.markNotificationRead(notificationId);
    fetchNotifications(moduleId);
    fetchUnreadCount(moduleId);
  }
}
