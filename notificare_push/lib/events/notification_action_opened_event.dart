import 'package:notificare/models/notificare_notification.dart';

class NotificationActionOpenedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  NotificationActionOpenedEvent({
    required this.notification,
    required this.action,
  });
}
