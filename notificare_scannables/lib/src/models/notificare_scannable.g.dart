// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_scannable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareScannable _$NotificareScannableFromJson(Map json) =>
    NotificareScannable(
      id: json['id'] as String,
      name: json['name'] as String,
      tag: json['tag'] as String,
      type: json['type'] as String,
      notification: json['notification'] == null
          ? null
          : NotificareNotification.fromJson(
              Map<String, dynamic>.from(json['notification'] as Map)),
    );

Map<String, dynamic> _$NotificareScannableToJson(
        NotificareScannable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tag': instance.tag,
      'type': instance.type,
      'notification': instance.notification?.toJson(),
    };
