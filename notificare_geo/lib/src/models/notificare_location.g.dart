// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareLocation _$NotificareLocationFromJson(Map json) => NotificareLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      course: (json['course'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      floor: json['floor'] as int?,
      horizontalAccuracy: (json['horizontalAccuracy'] as num).toDouble(),
      verticalAccuracy: (json['verticalAccuracy'] as num).toDouble(),
      timestamp: const NotificareIsoDateTimeConverter()
          .fromJson(json['timestamp'] as String),
    );

Map<String, dynamic> _$NotificareLocationToJson(NotificareLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'course': instance.course,
      'speed': instance.speed,
      'floor': instance.floor,
      'horizontalAccuracy': instance.horizontalAccuracy,
      'verticalAccuracy': instance.verticalAccuracy,
      'timestamp':
          const NotificareIsoDateTimeConverter().toJson(instance.timestamp),
    };
