import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_heading.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@NotificareIsoDateTimeConverter()
class NotificareHeading {
  final double magneticHeading;
  final double trueHeading;
  final double headingAccuracy;
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  NotificareHeading({
    required this.magneticHeading,
    required this.trueHeading,
    required this.headingAccuracy,
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  factory NotificareHeading.fromJson(Map<String, dynamic> json) =>
      _$NotificareHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareHeadingToJson(this);
}
