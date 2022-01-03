// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_action_failed_to_execute_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareActionFailedToExecuteEvent
    _$NotificareActionFailedToExecuteEventFromJson(Map json) =>
        NotificareActionFailedToExecuteEvent(
          notification: NotificareNotification.fromJson(
              Map<String, dynamic>.from(json['notification'] as Map)),
          action: NotificareNotificationAction.fromJson(
              Map<String, dynamic>.from(json['action'] as Map)),
          error: json['error'] as String?,
        );

Map<String, dynamic> _$NotificareActionFailedToExecuteEventToJson(
        NotificareActionFailedToExecuteEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'action': instance.action.toJson(),
      'error': instance.error,
    };
