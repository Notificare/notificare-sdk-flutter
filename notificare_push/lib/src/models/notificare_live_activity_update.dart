import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_live_activity_update.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@NotificareIsoDateTimeConverter()
class NotificareLiveActivityUpdate {
  final String activity;
  final String? title;
  final String? subtitle;
  final String? message;
  final Map<String, dynamic> content;
  final bool isFinal;
  final DateTime? dismissalDate;
  final DateTime timestamp;

  NotificareLiveActivityUpdate({
    required this.activity,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.content,
    required this.isFinal,
    required this.dismissalDate,
    required this.timestamp
  });

  factory NotificareLiveActivityUpdate.fromJson(Map<String, dynamic> json) =>
      _$NotificareLiveActivityUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareLiveActivityUpdateToJson(this);
}
