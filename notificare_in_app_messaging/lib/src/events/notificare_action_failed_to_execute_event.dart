import 'package:json_annotation/json_annotation.dart';
import 'package:notificare_in_app_messaging/src/models/notificare_in_app_message.dart';

part 'notificare_action_failed_to_execute_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionFailedToExecuteEvent {
  final NotificareInAppMessage message;
  final NotificareInAppMessageAction action;
  final String? error;

  NotificareActionFailedToExecuteEvent({
    required this.message,
    required this.action,
    required this.error,
  });

  factory NotificareActionFailedToExecuteEvent.fromJson(
          Map<String, dynamic> json) =>
      _$NotificareActionFailedToExecuteEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NotificareActionFailedToExecuteEventToJson(this);
}
