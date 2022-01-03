import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_notification_action_opened_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareNotificationActionOpenedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;

  NotificareNotificationActionOpenedEvent({
    required this.notification,
    required this.action,
  });

  factory NotificareNotificationActionOpenedEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareNotificationActionOpenedEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareNotificationActionOpenedEventToJson(this);
}
