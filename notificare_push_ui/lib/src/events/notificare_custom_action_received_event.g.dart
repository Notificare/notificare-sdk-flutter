// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_custom_action_received_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareCustomActionReceivedEvent
    _$NotificareCustomActionReceivedEventFromJson(Map json) =>
        NotificareCustomActionReceivedEvent(
          notification: NotificareNotification.fromJson(
              Map<String, dynamic>.from(json['notification'] as Map)),
          action: NotificareNotificationAction.fromJson(
              Map<String, dynamic>.from(json['action'] as Map)),
          uri: json['uri'] as String,
        );

Map<String, dynamic> _$NotificareCustomActionReceivedEventToJson(
        NotificareCustomActionReceivedEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'action': instance.action.toJson(),
      'uri': instance.uri,
    };
