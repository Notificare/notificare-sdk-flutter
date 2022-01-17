// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareUser _$NotificareUserFromJson(Map json) => NotificareUser(
      id: json['id'] as String,
      name: json['name'] as String,
      pushEmailAddress: json['pushEmailAddress'] as String?,
      segments:
          (json['segments'] as List<dynamic>).map((e) => e as String).toList(),
      registrationDate: const NotificareIsoDateTimeConverter()
          .fromJson(json['registrationDate'] as String),
      lastActive: const NotificareIsoDateTimeConverter()
          .fromJson(json['lastActive'] as String),
    );

Map<String, dynamic> _$NotificareUserToJson(NotificareUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pushEmailAddress': instance.pushEmailAddress,
      'segments': instance.segments,
      'registrationDate': const NotificareIsoDateTimeConverter()
          .toJson(instance.registrationDate),
      'lastActive':
          const NotificareIsoDateTimeConverter().toJson(instance.lastActive),
    };
