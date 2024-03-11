import 'package:json_annotation/json_annotation.dart';

part 'notificare_asset.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareAsset {
  final String title;
  final String? description;
  final String? key;
  final String? url;
  final NotificareAssetButton? button;
  final NotificareAssetMetaData? metaData;
  final Map<String, dynamic> extra;

  NotificareAsset({
    required this.title,
    required this.description,
    required this.key,
    required this.url,
    required this.button,
    required this.metaData,
    required this.extra,
  });

  factory NotificareAsset.fromJson(Map<String, dynamic> json) =>
      _$NotificareAssetFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareAssetToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareAssetButton {
  final String? label;
  final String? action;

  NotificareAssetButton({
    required this.label,
    required this.action,
  });

  factory NotificareAssetButton.fromJson(Map<String, dynamic> json) =>
      _$NotificareAssetButtonFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareAssetButtonToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareAssetMetaData {
  final String originalFileName;
  final String contentType;
  final int contentLength;

  NotificareAssetMetaData({
    required this.originalFileName,
    required this.contentType,
    required this.contentLength,
  });

  factory NotificareAssetMetaData.fromJson(Map<String, dynamic> json) =>
      _$NotificareAssetMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareAssetMetaDataToJson(this);
}
