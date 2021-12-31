// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_system_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareSystemNotification _$NotificareSystemNotificationFromJson(Map json) =>
    NotificareSystemNotification(
      id: json['id'] as String,
      type: json['type'] as String,
      extra: Map<String, String?>.from(json['extra'] as Map),
    );

Map<String, dynamic> _$NotificareSystemNotificationToJson(
        NotificareSystemNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'extra': instance.extra,
    };
