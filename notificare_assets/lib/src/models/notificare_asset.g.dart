// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareAsset _$NotificareAssetFromJson(Map json) => NotificareAsset(
      title: json['title'] as String,
      description: json['description'] as String?,
      key: json['key'] as String?,
      url: json['url'] as String?,
      button: json['button'] == null
          ? null
          : NotificareAssetButton.fromJson(
              Map<String, dynamic>.from(json['button'] as Map)),
      metaData: json['metaData'] == null
          ? null
          : NotificareAssetMetaData.fromJson(
              Map<String, dynamic>.from(json['metaData'] as Map)),
      extra: Map<String, dynamic>.from(json['extra'] as Map),
    );

Map<String, dynamic> _$NotificareAssetToJson(NotificareAsset instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'key': instance.key,
      'url': instance.url,
      'button': instance.button?.toJson(),
      'metaData': instance.metaData?.toJson(),
      'extra': instance.extra,
    };

NotificareAssetButton _$NotificareAssetButtonFromJson(Map json) =>
    NotificareAssetButton(
      label: json['label'] as String?,
      action: json['action'] as String?,
    );

Map<String, dynamic> _$NotificareAssetButtonToJson(
        NotificareAssetButton instance) =>
    <String, dynamic>{
      'label': instance.label,
      'action': instance.action,
    };

NotificareAssetMetaData _$NotificareAssetMetaDataFromJson(Map json) =>
    NotificareAssetMetaData(
      originalFileName: json['originalFileName'] as String,
      contentType: json['contentType'] as String,
      contentLength: json['contentLength'] as int,
    );

Map<String, dynamic> _$NotificareAssetMetaDataToJson(
        NotificareAssetMetaData instance) =>
    <String, dynamic>{
      'originalFileName': instance.originalFileName,
      'contentType': instance.contentType,
      'contentLength': instance.contentLength,
    };
