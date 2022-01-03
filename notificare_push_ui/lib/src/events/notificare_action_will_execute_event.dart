import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/models/notificare_notification.dart';

part 'notificare_action_will_execute_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionWillExecuteEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  NotificareActionWillExecuteEvent({
    required this.notification,
    required this.action,
  });

  factory NotificareActionWillExecuteEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionWillExecuteEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionWillExecuteEventToJson(this);
}
