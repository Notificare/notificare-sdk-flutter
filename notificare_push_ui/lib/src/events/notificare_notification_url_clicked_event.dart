import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/models/notificare_notification.dart';

part 'notificare_notification_url_clicked_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareNotificationUrlClickedEvent {
  final NotificareNotification notification;
  final String url;

  NotificareNotificationUrlClickedEvent({
    required this.notification,
    required this.url,
  });

  factory NotificareNotificationUrlClickedEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareNotificationUrlClickedEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareNotificationUrlClickedEventToJson(this);
}
