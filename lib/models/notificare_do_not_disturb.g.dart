// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_do_not_disturb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareDoNotDisturb _$NotificareDoNotDisturbFromJson(
    Map<String, dynamic> json) {
  return NotificareDoNotDisturb(
    start: json['start'] == null
        ? null
        : NotificareTime.fromJson(json['start'] as String),
    end: json['end'] == null
        ? null
        : NotificareTime.fromJson(json['end'] as String),
  );
}

Map<String, dynamic> _$NotificareDoNotDisturbToJson(
        NotificareDoNotDisturb instance) =>
    <String, dynamic>{
      'start': instance.start?.toJson(),
      'end': instance.end?.toJson(),
    };
