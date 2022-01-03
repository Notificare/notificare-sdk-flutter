import 'package:json_annotation/json_annotation.dart';

part 'notificare_system_notification.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareSystemNotification {
  final String id;
  final String type;
  final Map<String, String?> extra;

  NotificareSystemNotification({
    required this.id,
    required this.type,
    required this.extra,
  });

  factory NotificareSystemNotification.fromJson(Map<String, dynamic> json) =>
      _$NotificareSystemNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareSystemNotificationToJson(this);
}
