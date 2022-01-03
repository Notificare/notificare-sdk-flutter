// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareApplication _$NotificareApplicationFromJson(Map json) =>
    NotificareApplication(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      services: Map<String, bool>.from(json['services'] as Map),
      inboxConfig: json['inboxConfig'] == null
          ? null
          : NotificareInboxConfig.fromJson(
              Map<String, dynamic>.from(json['inboxConfig'] as Map)),
      regionConfig: json['regionConfig'] == null
          ? null
          : NotificareRegionConfig.fromJson(
              Map<String, dynamic>.from(json['regionConfig'] as Map)),
      userDataFields: (json['userDataFields'] as List<dynamic>)
          .map((e) => NotificareUserDataField.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      actionCategories: (json['actionCategories'] as List<dynamic>)
          .map((e) => NotificareActionCategory.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

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

NotificareInboxConfig _$NotificareInboxConfigFromJson(Map json) =>
    NotificareInboxConfig(
      useInbox: json['useInbox'] as bool,
      autoBadge: json['autoBadge'] as bool,
    );

Map<String, dynamic> _$NotificareInboxConfigToJson(
        NotificareInboxConfig instance) =>
    <String, dynamic>{
      'useInbox': instance.useInbox,
      'autoBadge': instance.autoBadge,
    };

NotificareRegionConfig _$NotificareRegionConfigFromJson(Map json) =>
    NotificareRegionConfig(
      proximityUUID: json['proximityUUID'] as String?,
    );

Map<String, dynamic> _$NotificareRegionConfigToJson(
        NotificareRegionConfig instance) =>
    <String, dynamic>{
      'proximityUUID': instance.proximityUUID,
    };

NotificareUserDataField _$NotificareUserDataFieldFromJson(Map json) =>
    NotificareUserDataField(
      type: json['type'] as String,
      key: json['key'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$NotificareUserDataFieldToJson(
        NotificareUserDataField instance) =>
    <String, dynamic>{
      'type': instance.type,
      'key': instance.key,
      'label': instance.label,
    };

NotificareActionCategory _$NotificareActionCategoryFromJson(Map json) =>
    NotificareActionCategory(
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => NotificareNotificationAction.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$NotificareActionCategoryToJson(
        NotificareActionCategory instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'actions': instance.actions.map((e) => e.toJson()).toList(),
    };
