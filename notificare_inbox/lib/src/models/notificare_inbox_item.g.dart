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
      time: const NotificareIsoDateTimeConverter()
          .fromJson(json['time'] as String),
      opened: json['opened'] as bool,
      expires: _$JsonConverterFromJson<String, DateTime>(
          json['expires'], const NotificareIsoDateTimeConverter().fromJson),
    );

Map<String, dynamic> _$NotificareInboxItemToJson(
        NotificareInboxItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification': instance.notification.toJson(),
      'time': const NotificareIsoDateTimeConverter().toJson(instance.time),
      'opened': instance.opened,
      'expires': _$JsonConverterToJson<String, DateTime>(
          instance.expires, const NotificareIsoDateTimeConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
