// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareDevice _$NotificareDeviceFromJson(Map json) => NotificareDevice(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      timeZoneOffset: (json['timeZoneOffset'] as num).toDouble(),
      osVersion: json['osVersion'] as String,
      sdkVersion: json['sdkVersion'] as String,
      appVersion: json['appVersion'] as String,
      deviceString: json['deviceString'] as String,
      language: json['language'] as String,
      region: json['region'] as String,
      transport: json['transport'] as String,
      dnd: json['dnd'] == null
          ? null
          : NotificareDoNotDisturb.fromJson(
              Map<String, dynamic>.from(json['dnd'] as Map)),
      userData: Map<String, String>.from(json['userData'] as Map),
      lastRegistered: const IsoDateTimeConverter()
          .fromJson(json['lastRegistered'] as String),
    );

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
    };
