import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/converters/iso_date_time_converter.dart';
import 'package:notificare/models/notificare_notification.dart';

part 'notificare_inbox_item.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@IsoDateTimeConverter()
class NotificareInboxItem {
  final String id;
  final NotificareNotification notification;
  final DateTime time;
  final bool opened;
  final DateTime? expires;

  NotificareInboxItem({
    required this.id,
    required this.notification,
    required this.time,
    required this.opened,
    required this.expires,
  });

  factory NotificareInboxItem.fromJson(Map<String, dynamic> json) => _$NotificareInboxItemFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareInboxItemToJson(this);
}
