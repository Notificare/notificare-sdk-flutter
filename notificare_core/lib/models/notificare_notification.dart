import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/converters/iso_date_time_converter.dart';

part 'notificare_notification.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@IsoDateTimeConverter()
class NotificareNotification {
  final String id;
  final bool partial;
  final String type;
  final DateTime time;
  final String? title;
  final String? subtitle;
  final String message;
  final List<NotificareNotificationContent> content;
  final List<NotificareNotificationAction> actions;
  final List<NotificareNotificationAttachment> attachments;
  final Map<String, dynamic> extra;

  NotificareNotification({
    required this.id,
    required this.partial,
    required this.type,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.content,
    required this.actions,
    required this.attachments,
    required this.extra,
  });

  factory NotificareNotification.fromJson(Map<String, dynamic> json) => _$NotificareNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareNotificationToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareNotificationContent {
  final String type;
  final dynamic data;

  NotificareNotificationContent({
    required this.type,
    required this.data,
  });

  factory NotificareNotificationContent.fromJson(Map<String, dynamic> json) =>
      _$NotificareNotificationContentFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareNotificationContentToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareNotificationAction {
  final String type;
  final String label;
  final String? target;
  final bool keyboard;
  final bool camera;

  NotificareNotificationAction({
    required this.type,
    required this.label,
    required this.target,
    required this.keyboard,
    required this.camera,
  });

  factory NotificareNotificationAction.fromJson(Map<String, dynamic> json) =>
      _$NotificareNotificationActionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareNotificationActionToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareNotificationAttachment {
  final String mimeType;
  final String uri;

  NotificareNotificationAttachment({
    required this.mimeType,
    required this.uri,
  });

  factory NotificareNotificationAttachment.fromJson(Map<String, dynamic> json) =>
      _$NotificareNotificationAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareNotificationAttachmentToJson(this);
}
