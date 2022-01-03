// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_heading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareHeading _$NotificareHeadingFromJson(Map json) => NotificareHeading(
      magneticHeading: (json['magneticHeading'] as num).toDouble(),
      trueHeading: (json['trueHeading'] as num).toDouble(),
      headingAccuracy: (json['headingAccuracy'] as num).toDouble(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      timestamp:
          const NotificareIsoDateTimeConverter().fromJson(json['timestamp'] as String),
    );

Map<String, dynamic> _$NotificareHeadingToJson(NotificareHeading instance) =>
    <String, dynamic>{
      'magneticHeading': instance.magneticHeading,
      'trueHeading': instance.trueHeading,
      'headingAccuracy': instance.headingAccuracy,
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'timestamp': const NotificareIsoDateTimeConverter().toJson(instance.timestamp),
    };
