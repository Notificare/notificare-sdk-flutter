import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_action_not_executed_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionNotExecutedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  NotificareActionNotExecutedEvent({
    required this.notification,
    required this.action,
  });

  factory NotificareActionNotExecutedEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionNotExecutedEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionNotExecutedEventToJson(this);
}
