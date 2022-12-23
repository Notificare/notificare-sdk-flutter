import 'package:json_annotation/json_annotation.dart';
import 'notificare_user_inbox_item.dart';

part 'notificare_user_inbox_response.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareUserInboxResponse {
  final int count;
  final int unread;
  final List<NotificareUserInboxItem> items;

  NotificareUserInboxResponse({
    required this.count,
    required this.unread,
    required this.items,
  });

  factory NotificareUserInboxResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserInboxResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserInboxResponseToJson(this);
}
