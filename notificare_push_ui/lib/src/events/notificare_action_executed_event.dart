import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/models/notificare_notification.dart';

part 'notificare_action_executed_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionExecutedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  NotificareActionExecutedEvent({
    required this.notification,
    required this.action,
  });

  factory NotificareActionExecutedEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionExecutedEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionExecutedEventToJson(this);
}
