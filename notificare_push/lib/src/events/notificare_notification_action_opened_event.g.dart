// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_notification_action_opened_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareNotificationActionOpenedEvent
    _$NotificareNotificationActionOpenedEventFromJson(Map json) =>
        NotificareNotificationActionOpenedEvent(
          notification: NotificareNotification.fromJson(
              Map<String, dynamic>.from(json['notification'] as Map)),
          action: NotificareNotificationAction.fromJson(
              Map<String, dynamic>.from(json['action'] as Map)),
        );

Map<String, dynamic> _$NotificareNotificationActionOpenedEventToJson(
        NotificareNotificationActionOpenedEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'action': instance.action.toJson(),
    };
