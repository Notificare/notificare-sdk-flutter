// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareApplication _$NotificareApplicationFromJson(
    Map<String, dynamic> json) {
  return NotificareApplication(
    json['id'] as String,
    json['name'] as String,
    json['category'] as String,
    (json['services'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as bool),
    ),
    json['inboxConfig'] == null
        ? null
        : NotificareInboxConfig.fromJson(
            json['inboxConfig'] as Map<String, dynamic>),
    json['regionConfig'] == null
        ? null
        : NotificareRegionConfig.fromJson(
            json['regionConfig'] as Map<String, dynamic>),
    (json['userDataFields'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareUserDataField.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['actionCategories'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareActionCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NotificareApplicationToJson(
        NotificareApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'services': instance.services,
      'inboxConfig': instance.inboxConfig,
      'regionConfig': instance.regionConfig,
      'userDataFields': instance.userDataFields,
      'actionCategories': instance.actionCategories,
    };

NotificareInboxConfig _$NotificareInboxConfigFromJson(
    Map<String, dynamic> json) {
  return NotificareInboxConfig(
    json['useInbox'] as bool,
    json['autoBadge'] as bool,
  );
}

Map<String, dynamic> _$NotificareInboxConfigToJson(
        NotificareInboxConfig instance) =>
    <String, dynamic>{
      'useInbox': instance.useInbox,
      'autoBadge': instance.autoBadge,
    };

NotificareRegionConfig _$NotificareRegionConfigFromJson(
    Map<String, dynamic> json) {
  return NotificareRegionConfig(
    json['proximityUUID'] as String,
  );
}

Map<String, dynamic> _$NotificareRegionConfigToJson(
        NotificareRegionConfig instance) =>
    <String, dynamic>{
      'proximityUUID': instance.proximityUUID,
    };

NotificareUserDataField _$NotificareUserDataFieldFromJson(
    Map<String, dynamic> json) {
  return NotificareUserDataField(
    json['type'] as String,
    json['key'] as String,
    json['label'] as String,
  );
}

Map<String, dynamic> _$NotificareUserDataFieldToJson(
        NotificareUserDataField instance) =>
    <String, dynamic>{
      'type': instance.type,
      'key': instance.key,
      'label': instance.label,
    };

NotificareActionCategory _$NotificareActionCategoryFromJson(
    Map<String, dynamic> json) {
  return NotificareActionCategory(
    json['type'] as String,
    json['label'] as String,
    json['target'] as String,
    json['camera'] as bool,
    json['keyboard'] as bool,
    json['destructive'] as bool,
  );
}

Map<String, dynamic> _$NotificareActionCategoryToJson(
        NotificareActionCategory instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'target': instance.target,
      'camera': instance.camera,
      'keyboard': instance.keyboard,
      'destructive': instance.destructive,
    };
