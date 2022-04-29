// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_unknown_notification_action_opened_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareUnknownNotificationActionOpenedEvent
    _$NotificareUnknownNotificationActionOpenedEventFromJson(Map json) =>
        NotificareUnknownNotificationActionOpenedEvent(
          notification: Map<String, dynamic>.from(json['notification'] as Map),
          action: json['action'] as String,
          responseText: json['responseText'] as String?,
        );

Map<String, dynamic> _$NotificareUnknownNotificationActionOpenedEventToJson(
        NotificareUnknownNotificationActionOpenedEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification,
      'action': instance.action,
      'responseText': instance.responseText,
    };
