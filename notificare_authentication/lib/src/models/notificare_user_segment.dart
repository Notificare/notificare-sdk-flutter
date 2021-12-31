import 'package:json_annotation/json_annotation.dart';

part 'notificare_user_segment.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareUserSegment {
  final String id;
  final String name;
  final String? description;

  NotificareUserSegment({
    required this.id,
    required this.name,
    required this.description,
  });

  factory NotificareUserSegment.fromJson(Map<String, dynamic> json) => _$NotificareUserSegmentFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserSegmentToJson(this);
}
