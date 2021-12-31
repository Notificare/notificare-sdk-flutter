import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/converters/iso_date_time_converter.dart';

part 'notificare_location.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@IsoDateTimeConverter()
class NotificareLocation {
  final double latitude;
  final double longitude;
  final double altitude;
  final double course;
  final double speed;
  final int? floor;
  final double horizontalAccuracy;
  final double verticalAccuracy;
  final DateTime timestamp;

  NotificareLocation({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.course,
    required this.speed,
    required this.floor,
    required this.horizontalAccuracy,
    required this.verticalAccuracy,
    required this.timestamp,
  });

  factory NotificareLocation.fromJson(Map<String, dynamic> json) => _$NotificareLocationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareLocationToJson(this);
}
