// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareNotification _$NotificareNotificationFromJson(Map json) =>
    NotificareNotification(
      id: json['id'] as String,
      partial: json['partial'] as bool,
      type: json['type'] as String,
      time: const NotificareIsoDateTimeConverter().fromJson(json['time'] as String),
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      message: json['message'] as String,
      content: (json['content'] as List<dynamic>)
          .map((e) => NotificareNotificationContent.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      actions: (json['actions'] as List<dynamic>)
          .map((e) => NotificareNotificationAction.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => NotificareNotificationAttachment.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      extra: Map<String, dynamic>.from(json['extra'] as Map),
    );

Map<String, dynamic> _$NotificareNotificationToJson(
        NotificareNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partial': instance.partial,
      'type': instance.type,
      'time': const NotificareIsoDateTimeConverter().toJson(instance.time),
      'title': instance.title,
      'subtitle': instance.subtitle,
      'message': instance.message,
      'content': instance.content.map((e) => e.toJson()).toList(),
      'actions': instance.actions.map((e) => e.toJson()).toList(),
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
      'extra': instance.extra,
    };

NotificareNotificationContent _$NotificareNotificationContentFromJson(
        Map json) =>
    NotificareNotificationContent(
      type: json['type'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$NotificareNotificationContentToJson(
        NotificareNotificationContent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };

NotificareNotificationAction _$NotificareNotificationActionFromJson(Map json) =>
    NotificareNotificationAction(
      type: json['type'] as String,
      label: json['label'] as String,
      target: json['target'] as String?,
      keyboard: json['keyboard'] as bool,
      camera: json['camera'] as bool,
      destructive: json['destructive'] as bool?,
      icon: json['icon'] == null
          ? null
          : NotificareNotificationActionIcon.fromJson(
              Map<String, dynamic>.from(json['icon'] as Map)),
    );

Map<String, dynamic> _$NotificareNotificationActionToJson(
        NotificareNotificationAction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'target': instance.target,
      'keyboard': instance.keyboard,
      'camera': instance.camera,
      'destructive': instance.destructive,
      'icon': instance.icon?.toJson(),
    };

NotificareNotificationActionIcon _$NotificareNotificationActionIconFromJson(
        Map json) =>
    NotificareNotificationActionIcon(
      android: json['android'] as String?,
      ios: json['ios'] as String?,
      web: json['web'] as String?,
    );

Map<String, dynamic> _$NotificareNotificationActionIconToJson(
        NotificareNotificationActionIcon instance) =>
    <String, dynamic>{
      'android': instance.android,
      'ios': instance.ios,
      'web': instance.web,
    };

NotificareNotificationAttachment _$NotificareNotificationAttachmentFromJson(
        Map json) =>
    NotificareNotificationAttachment(
      mimeType: json['mimeType'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$NotificareNotificationAttachmentToJson(
        NotificareNotificationAttachment instance) =>
    <String, dynamic>{
      'mimeType': instance.mimeType,
      'uri': instance.uri,
    };
