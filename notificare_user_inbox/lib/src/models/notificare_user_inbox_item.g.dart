// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_user_inbox_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareUserInboxItem _$NotificareUserInboxItemFromJson(Map json) =>
    NotificareUserInboxItem(
      id: json['id'] as String,
      notification: NotificareNotification.fromJson(
          Map<String, dynamic>.from(json['notification'] as Map)),
      time: const NotificareIsoDateTimeConverter()
          .fromJson(json['time'] as String),
      opened: json['opened'] as bool,
      expires: const NotificareNullableIsoDateTimeConverter()
          .fromJson(json['expires'] as String?),
    );

Map<String, dynamic> _$NotificareUserInboxItemToJson(
        NotificareUserInboxItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification': instance.notification.toJson(),
      'time': const NotificareIsoDateTimeConverter().toJson(instance.time),
      'opened': instance.opened,
      'expires': const NotificareNullableIsoDateTimeConverter()
          .toJson(instance.expires),
    };
