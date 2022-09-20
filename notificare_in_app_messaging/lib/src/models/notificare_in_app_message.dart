import 'package:json_annotation/json_annotation.dart';

part 'notificare_in_app_message.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareInAppMessage {
  final String id;
  final String name;
  final String type;
  final List<String> context;
  final String? title;
  final String? message;
  final String? image;
  final String? landscapeImage;
  final int delaySeconds;
  final NotificareInAppMessageAction? primaryAction;
  final NotificareInAppMessageAction? secondaryAction;

  NotificareInAppMessage({
    required this.id,
    required this.name,
    required this.type,
    required this.context,
    required this.title,
    required this.message,
    required this.image,
    required this.landscapeImage,
    required this.delaySeconds,
    required this.primaryAction,
    required this.secondaryAction,
  });

  factory NotificareInAppMessage.fromJson(Map<String, dynamic> json) => _$NotificareInAppMessageFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareInAppMessageToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareInAppMessageAction {
  final String? label;
  final bool destructive;
  final String? url;

  NotificareInAppMessageAction({
    required this.label,
    required this.destructive,
    required this.url,
  });

  factory NotificareInAppMessageAction.fromJson(Map<String, dynamic> json) =>
      _$NotificareInAppMessageActionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareInAppMessageActionToJson(this);
}
