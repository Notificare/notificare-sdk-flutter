// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_user_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareUserPreference _$NotificareUserPreferenceFromJson(Map json) {
  return NotificareUserPreference(
    id: json['id'] as String,
    label: json['label'] as String,
    type: json['type'] as String,
    options: (json['options'] as List<dynamic>)
        .map((e) => NotificareUserPreferenceOption.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList(),
    position: json['position'] as int,
  );
}

Map<String, dynamic> _$NotificareUserPreferenceToJson(
        NotificareUserPreference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'position': instance.position,
    };

NotificareUserPreferenceOption _$NotificareUserPreferenceOptionFromJson(
    Map json) {
  return NotificareUserPreferenceOption(
    label: json['label'] as String,
    segmentId: json['segmentId'] as String,
    selected: json['selected'] as bool,
  );
}

Map<String, dynamic> _$NotificareUserPreferenceOptionToJson(
        NotificareUserPreferenceOption instance) =>
    <String, dynamic>{
      'label': instance.label,
      'segmentId': instance.segmentId,
      'selected': instance.selected,
    };
