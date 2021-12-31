import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/converters/iso_date_time_converter.dart';

part 'notificare_user.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@IsoDateTimeConverter()
class NotificareUser {
  final String id;
  final String name;
  final String? pushEmailAddress;
  final List<String> segments;
  final DateTime registrationDate;
  final DateTime lastActive;

  NotificareUser({
    required this.id,
    required this.name,
    required this.pushEmailAddress,
    required this.segments,
    required this.registrationDate,
    required this.lastActive,
  });

  factory NotificareUser.fromJson(Map<String, dynamic> json) => _$NotificareUserFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareUserToJson(this);
}
