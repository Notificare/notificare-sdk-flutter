import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/models/notificare_notification.dart';

part 'notificare_action_failed_to_execute_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionFailedToExecuteEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;
  final String? error;

  NotificareActionFailedToExecuteEvent({
    required this.notification,
    required this.action,
    required this.error,
  });

  factory NotificareActionFailedToExecuteEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionFailedToExecuteEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionFailedToExecuteEventToJson(this);
}
