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
      dnd: json['dnd'] == null
          ? null
          : NotificareDoNotDisturb.fromJson(
              Map<String, dynamic>.from(json['dnd'] as Map)),
      userData: Map<String, String>.from(json['userData'] as Map),
    );

Map<String, dynamic> _$NotificareDeviceToJson(NotificareDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'timeZoneOffset': instance.timeZoneOffset,
      'dnd': instance.dnd?.toJson(),
      'userData': instance.userData,
    };
