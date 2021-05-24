// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareDevice _$NotificareDeviceFromJson(Map json) {
  return NotificareDevice(
    json['id'] as String,
    json['userId'] as String?,
    json['userName'] as String?,
    (json['timeZoneOffset'] as num).toDouble(),
    json['osVersion'] as String,
    json['sdkVersion'] as String,
    json['appVersion'] as String,
    json['deviceString'] as String,
    json['language'] as String,
    json['region'] as String,
    json['transport'] as String,
    json['dnd'] == null
        ? null
        : NotificareDoNotDisturb.fromJson(
            Map<String, dynamic>.from(json['dnd'] as Map)),
    Map<String, String>.from(json['userData'] as Map),
    const IsoDateTimeConverter().fromJson(json['lastRegistered'] as String),
    json['allowedUI'] as bool,
    json['bluetoothEnabled'] as bool,
  );
}

Map<String, dynamic> _$NotificareDeviceToJson(NotificareDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'timeZoneOffset': instance.timeZoneOffset,
      'osVersion': instance.osVersion,
      'sdkVersion': instance.sdkVersion,
      'appVersion': instance.appVersion,
      'deviceString': instance.deviceString,
      'language': instance.language,
      'region': instance.region,
      'transport': instance.transport,
      'dnd': instance.dnd?.toJson(),
      'userData': instance.userData,
      'lastRegistered':
          const IsoDateTimeConverter().toJson(instance.lastRegistered),
      'allowedUI': instance.allowedUI,
      'bluetoothEnabled': instance.bluetoothEnabled,
    };
