import 'package:json_annotation/json_annotation.dart';

part 'notificare_user_preference.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareUserPreference {
  final String id;
  final String label;
  final String type;
  final List<NotificareUserPreferenceOption> options;
  final int position;

  NotificareUserPreference({
    required this.id,
    required this.label,
    required this.type,
    required this.options,
    required this.position,
  });

  factory NotificareUserPreference.fromJson(Map<String, dynamic> json) => _$NotificareUserPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserPreferenceToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareUserPreferenceOption {
  final String label;
  final String segmentId;
  final bool selected;

  NotificareUserPreferenceOption({
    required this.label,
    required this.segmentId,
    required this.selected,
  });

  factory NotificareUserPreferenceOption.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserPreferenceOptionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserPreferenceOptionToJson(this);
}
