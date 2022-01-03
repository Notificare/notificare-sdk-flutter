// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_action_will_execute_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareActionWillExecuteEvent _$NotificareActionWillExecuteEventFromJson(
        Map json) =>
    NotificareActionWillExecuteEvent(
      notification: NotificareNotification.fromJson(
          Map<String, dynamic>.from(json['notification'] as Map)),
      action: NotificareNotificationAction.fromJson(
          Map<String, dynamic>.from(json['action'] as Map)),
    );

Map<String, dynamic> _$NotificareActionWillExecuteEventToJson(
        NotificareActionWillExecuteEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'action': instance.action.toJson(),
    };
