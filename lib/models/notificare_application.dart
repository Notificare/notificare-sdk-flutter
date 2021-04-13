import 'package:json_annotation/json_annotation.dart';

part 'notificare_application.g.dart';

@JsonSerializable()
class NotificareApplication {
  final String id;
  final String name;
  final String category;
  final Map<String, bool> services;
  final NotificareInboxConfig? inboxConfig; // nullable
  final NotificareRegionConfig? regionConfig; // nullable
  final List<NotificareUserDataField> userDataFields;
  final List<NotificareActionCategory> actionCategories;

  NotificareApplication(
    this.id,
    this.name,
    this.category,
    this.services,
    this.inboxConfig,
    this.regionConfig,
    this.userDataFields,
    this.actionCategories,
  );

  factory NotificareApplication.fromJson(Map<String, dynamic> json) => _$NotificareApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareApplicationToJson(this);
}

@JsonSerializable()
class NotificareInboxConfig {
  final bool useInbox;
  final bool autoBadge;

  NotificareInboxConfig(
    this.useInbox,
    this.autoBadge,
  );

  factory NotificareInboxConfig.fromJson(Map<String, dynamic> json) => _$NotificareInboxConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareInboxConfigToJson(this);
}

@JsonSerializable()
class NotificareRegionConfig {
  final String? proximityUUID;

  NotificareRegionConfig(
    this.proximityUUID,
  );

  factory NotificareRegionConfig.fromJson(Map<String, dynamic> json) => _$NotificareRegionConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareRegionConfigToJson(this);
}

@JsonSerializable()
class NotificareUserDataField {
  final String type;
  final String key;
  final String label;

  NotificareUserDataField(
    this.type,
    this.key,
    this.label,
  );

  factory NotificareUserDataField.fromJson(Map<String, dynamic> json) => _$NotificareUserDataFieldFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserDataFieldToJson(this);
}

@JsonSerializable()
class NotificareActionCategory {
  final String? type;
  final String? label;
  final String? target;
  final bool? camera;
  final bool? keyboard;
  final bool? destructive;

  NotificareActionCategory(
    this.type,
    this.label,
    this.target,
    this.camera,
    this.keyboard,
    this.destructive,
  );

  factory NotificareActionCategory.fromJson(Map<String, dynamic> json) => _$NotificareActionCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareActionCategoryToJson(this);
}
