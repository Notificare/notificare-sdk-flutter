import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_user_inbox_item.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@NotificareIsoDateTimeConverter()
class NotificareUserInboxItem {
  final String id;
  final NotificareNotification notification;
  final DateTime time;
  final bool opened;
  final DateTime? expires;

  NotificareUserInboxItem({
    required this.id,
    required this.notification,
    required this.time,
    required this.opened,
    required this.expires,
  });

  factory NotificareUserInboxItem.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserInboxItemFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserInboxItemToJson(this);
}
