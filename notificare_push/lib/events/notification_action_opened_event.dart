import 'package:notificare/notificare.dart';

class NotificationActionOpenedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  NotificationActionOpenedEvent({
    required this.notification,
    required this.action,
  });
}
