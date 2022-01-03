import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/models/notificare_notification.dart';

part 'notificare_custom_action_received_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareCustomActionReceivedEvent {
  final NotificareNotification notification;
  final NotificareNotificationAction action;
  final String uri;

  NotificareCustomActionReceivedEvent({
    required this.notification,
    required this.action,
    required this.uri,
  });

  factory NotificareCustomActionReceivedEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareCustomActionReceivedEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareCustomActionReceivedEventToJson(this);
}
