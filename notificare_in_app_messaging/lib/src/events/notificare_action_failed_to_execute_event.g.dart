// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_action_failed_to_execute_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareActionFailedToExecuteEvent
    _$NotificareActionFailedToExecuteEventFromJson(Map json) =>
        NotificareActionFailedToExecuteEvent(
          message: NotificareInAppMessage.fromJson(
              Map<String, dynamic>.from(json['message'] as Map)),
          action: NotificareInAppMessageAction.fromJson(
              Map<String, dynamic>.from(json['action'] as Map)),
          error: json['error'] as String?,
        );

Map<String, dynamic> _$NotificareActionFailedToExecuteEventToJson(
        NotificareActionFailedToExecuteEvent instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
      'action': instance.action.toJson(),
      'error': instance.error,
    };
