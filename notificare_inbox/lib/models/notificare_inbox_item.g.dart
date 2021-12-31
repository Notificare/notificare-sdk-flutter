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
      time: const IsoDateTimeConverter().fromJson(json['time'] as String),
      opened: json['opened'] as bool,
      expires: json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
      visible: json['visible'] as bool,
    );

Map<String, dynamic> _$NotificareInboxItemToJson(
        NotificareInboxItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification': instance.notification.toJson(),
      'time': const IsoDateTimeConverter().toJson(instance.time),
      'opened': instance.opened,
      'expires': instance.expires?.toIso8601String(),
      'visible': instance.visible,
    };
