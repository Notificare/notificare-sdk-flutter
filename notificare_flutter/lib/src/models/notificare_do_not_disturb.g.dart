// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_do_not_disturb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareDoNotDisturb _$NotificareDoNotDisturbFromJson(Map json) =>
    NotificareDoNotDisturb(
      start: NotificareTime.fromJson(json['start'] as String),
      end: NotificareTime.fromJson(json['end'] as String),
    );

Map<String, dynamic> _$NotificareDoNotDisturbToJson(
        NotificareDoNotDisturb instance) =>
    <String, dynamic>{
      'start': instance.start.toJson(),
      'end': instance.end.toJson(),
    };
