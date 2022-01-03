import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_visit.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@NotificareIsoDateTimeConverter()
class NotificareVisit {
  final DateTime departureDate;
  final DateTime arrivalDate;
  final double latitude;
  final double longitude;

  NotificareVisit({
    required this.departureDate,
    required this.arrivalDate,
    required this.latitude,
    required this.longitude,
  });

  factory NotificareVisit.fromJson(Map<String, dynamic> json) => _$NotificareVisitFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareVisitToJson(this);
}
