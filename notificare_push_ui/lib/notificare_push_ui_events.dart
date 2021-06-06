import 'package:notificare/models/notificare_notification.dart';

class NotificationUrlClickedEvent {
  final NotificareNotification notification;
  final String url;

  NotificationUrlClickedEvent({
    required this.notification,
    required this.url,
  });
}

class ActionWillExecuteEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  ActionWillExecuteEvent({
    required this.notification,
    required this.action,
  });
}

class ActionExecutedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  ActionExecutedEvent({
    required this.notification,
    required this.action,
  });
}

class ActionNotExecutedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  ActionNotExecutedEvent({
    required this.notification,
    required this.action,
  });
}

class ActionFailedToExecuteEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;
  final String? error;

  ActionFailedToExecuteEvent({
    required this.notification,
    required this.action,
    required this.error,
  });
}
