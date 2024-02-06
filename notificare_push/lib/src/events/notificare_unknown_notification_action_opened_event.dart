import 'package:json_annotation/json_annotation.dart';

part 'notificare_unknown_notification_action_opened_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareUnknownNotificationActionOpenedEvent {
  final Map<String, dynamic> notification;
  final String action;
  final String? responseText;

  NotificareUnknownNotificationActionOpenedEvent({
    required this.notification,
    required this.action,
    required this.responseText,
  });

  factory NotificareUnknownNotificationActionOpenedEvent.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NotificareUnknownNotificationActionOpenedEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NotificareUnknownNotificationActionOpenedEventToJson(this);
}
