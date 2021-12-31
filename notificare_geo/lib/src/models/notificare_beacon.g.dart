// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_beacon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareBeacon _$NotificareBeaconFromJson(Map json) => NotificareBeacon(
      id: json['id'] as String,
      name: json['name'] as String,
      major: json['major'] as int,
      minor: json['minor'] as int?,
      triggers: json['triggers'] as bool,
      proximity: json['proximity'] as String,
    );

Map<String, dynamic> _$NotificareBeaconToJson(NotificareBeacon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'major': instance.major,
      'minor': instance.minor,
      'triggers': instance.triggers,
      'proximity': instance.proximity,
    };
