// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_inbox_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareInboxItem _$NotificareInboxItemFromJson(Map json) =>
    NotificareInboxItem(
      id: json['id'] as String,
      notification: NotificareNotification.fromJson(
          Map<String, dynamic>.from(json['notification'] as Map)),
      time: const NotificareIsoDateTimeConverter().fromJson(json['time'] as String),
      opened: json['opened'] as bool,
      expires: const NotificareNullableIsoDateTimeConverter()
          .fromJson(json['expires'] as String?),
    );

Map<String, dynamic> _$NotificareInboxItemToJson(
        NotificareInboxItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification': instance.notification.toJson(),
      'time': const NotificareIsoDateTimeConverter().toJson(instance.time),
      'opened': instance.opened,
      'expires': instance.expires?.toIso8601String(),
    };
