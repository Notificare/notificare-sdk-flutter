// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_action_executed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareActionExecutedEvent _$NotificareActionExecutedEventFromJson(
        Map json) =>
    NotificareActionExecutedEvent(
      notification: NotificareNotification.fromJson(
          Map<String, dynamic>.from(json['notification'] as Map)),
      action: NotificareNotificationAction.fromJson(
          Map<String, dynamic>.from(json['action'] as Map)),
    );

Map<String, dynamic> _$NotificareActionExecutedEventToJson(
        NotificareActionExecutedEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'action': instance.action.toJson(),
    };
