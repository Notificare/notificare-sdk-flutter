import 'package:json_annotation/json_annotation.dart';

part 'notificare_application.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareApplication {
  final String id;
  final String name;
  final String category;
  final Map<String, bool> services;
  final NotificareInboxConfig? inboxConfig;
  final NotificareRegionConfig? regionConfig;
  final List<NotificareUserDataField> userDataFields;
  final List<NotificareActionCategory> actionCategories;

  NotificareApplication({
    required this.id,
    required this.name,
    required this.category,
    required this.services,
    this.inboxConfig,
    this.regionConfig,
    required this.userDataFields,
    required this.actionCategories,
  });

  factory NotificareApplication.fromJson(Map<String, dynamic> json) => _$NotificareApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareApplicationToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareInboxConfig {
  final bool useInbox;
  final bool autoBadge;

  NotificareInboxConfig({
    required this.useInbox,
    required this.autoBadge,
  });

  factory NotificareInboxConfig.fromJson(Map<String, dynamic> json) => _$NotificareInboxConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareInboxConfigToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareRegionConfig {
  final String? proximityUUID;

  NotificareRegionConfig({
    this.proximityUUID,
  });

  factory NotificareRegionConfig.fromJson(Map<String, dynamic> json) => _$NotificareRegionConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareRegionConfigToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareUserDataField {
  final String type;
  final String key;
  final String label;

  NotificareUserDataField({
    required this.type,
    required this.key,
    required this.label,
  });

  factory NotificareUserDataField.fromJson(Map<String, dynamic> json) => _$NotificareUserDataFieldFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserDataFieldToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionCategory {
  final String type;
  final String name;
  final String? description;
  final List<NotificareActionCategoryAction> actions;

  NotificareActionCategory({
    required this.type,
    required this.name,
    this.description,
    required this.actions,
  });

  factory NotificareActionCategory.fromJson(Map<String, dynamic> json) => _$NotificareActionCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionCategoryToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionCategoryAction {
  final String type;
  final String label;
  final String? target;
  final bool camera;
  final bool keyboard;
  final bool destructive;
  final NotificareActionCategoryActionIcon? icon;

  NotificareActionCategoryAction({
    required this.type,
    required this.label,
    this.target,
    required this.camera,
    required this.keyboard,
    required this.destructive,
    this.icon,
  });

  factory NotificareActionCategoryAction.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionCategoryActionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionCategoryActionToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareActionCategoryActionIcon {
  final String? android;
  final String? ios;
  final String? web;

  NotificareActionCategoryActionIcon({
    this.android,
    this.ios,
    this.web,
  });

  factory NotificareActionCategoryActionIcon.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionCategoryActionIconFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionCategoryActionIconToJson(this);
}
