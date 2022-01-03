// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_action_not_executed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareActionNotExecutedEvent _$NotificareActionNotExecutedEventFromJson(
        Map json) =>
    NotificareActionNotExecutedEvent(
      notification: NotificareNotification.fromJson(
          Map<String, dynamic>.from(json['notification'] as Map)),
      action: NotificareNotificationAction.fromJson(
          Map<String, dynamic>.from(json['action'] as Map)),
    );

Map<String, dynamic> _$NotificareActionNotExecutedEventToJson(
        NotificareActionNotExecutedEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'action': instance.action.toJson(),
    };
