// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareApplication _$NotificareApplicationFromJson(Map json) {
  return NotificareApplication(
    json['id'] as String,
    json['name'] as String,
    json['category'] as String,
    Map<String, bool>.from(json['services'] as Map),
    json['inboxConfig'] == null
        ? null
        : NotificareInboxConfig.fromJson(
            Map<String, dynamic>.from(json['inboxConfig'] as Map)),
    json['regionConfig'] == null
        ? null
        : NotificareRegionConfig.fromJson(
            Map<String, dynamic>.from(json['regionConfig'] as Map)),
    (json['userDataFields'] as List<dynamic>)
        .map((e) => NotificareUserDataField.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList(),
    (json['actionCategories'] as List<dynamic>)
        .map((e) => NotificareActionCategory.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}

Map<String, dynamic> _$NotificareApplicationToJson(
        NotificareApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'services': instance.services,
      'inboxConfig': instance.inboxConfig?.toJson(),
      'regionConfig': instance.regionConfig?.toJson(),
      'userDataFields': instance.userDataFields.map((e) => e.toJson()).toList(),
      'actionCategories':
          instance.actionCategories.map((e) => e.toJson()).toList(),
    };

NotificareInboxConfig _$NotificareInboxConfigFromJson(Map json) {
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

NotificareRegionConfig _$NotificareRegionConfigFromJson(Map json) {
  return NotificareRegionConfig(
    json['proximityUUID'] as String?,
  );
}

Map<String, dynamic> _$NotificareRegionConfigToJson(
        NotificareRegionConfig instance) =>
    <String, dynamic>{
      'proximityUUID': instance.proximityUUID,
    };

NotificareUserDataField _$NotificareUserDataFieldFromJson(Map json) {
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

NotificareActionCategory _$NotificareActionCategoryFromJson(Map json) {
  return NotificareActionCategory(
    json['type'] as String,
    json['name'] as String,
    (json['actions'] as List<dynamic>)
        .map((e) => NotificareNotificationAction.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}

Map<String, dynamic> _$NotificareActionCategoryToJson(
        NotificareActionCategory instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'actions': instance.actions.map((e) => e.toJson()).toList(),
    };
