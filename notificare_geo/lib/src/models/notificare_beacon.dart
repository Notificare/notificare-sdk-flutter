import 'package:json_annotation/json_annotation.dart';

part 'notificare_beacon.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareBeacon {
  final String id;
  final String name;
  final int major;
  final int? minor;
  final bool triggers;
  final String proximity;

  NotificareBeacon({
    required this.id,
    required this.name,
    required this.major,
    required this.minor,
    required this.triggers,
    required this.proximity,
  });

  factory NotificareBeacon.fromJson(Map<String, dynamic> json) =>
      _$NotificareBeaconFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareBeaconToJson(this);
}
