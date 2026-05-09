import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/notification/data/model/notification_model.dart';

class NotificationState {
  final List<NotificationModel> alerts;
  final List<NotificationModel> notifications;
  final Requestenum status;
  final String? errorMessage;
  final int unreadCount;

  NotificationState({
    this.alerts = const [],
    this.notifications = const [],
    this.status = Requestenum.init,
    this.errorMessage,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    List<NotificationModel>? alerts,
    List<NotificationModel>? notifications,
    Requestenum? status,
    String? errorMessage,
    int? unreadCount,
  }) {
    return NotificationState(
      alerts: alerts ?? this.alerts,
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
