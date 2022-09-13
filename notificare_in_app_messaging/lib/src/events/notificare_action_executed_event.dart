import 'package:json_annotation/json_annotation.dart';
import 'package:notificare_in_app_messaging/src/models/notificare_in_app_message.dart';

part 'notificare_action_executed_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionExecutedEvent {
  final NotificareInAppMessage message;
  final NotificareInAppMessageAction action;

  NotificareActionExecutedEvent({
    required this.message,
    required this.action,
  });

  factory NotificareActionExecutedEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionExecutedEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionExecutedEventToJson(this);
}
