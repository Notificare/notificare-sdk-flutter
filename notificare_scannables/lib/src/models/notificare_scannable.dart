import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_scannable.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareScannable {
  final String id;
  final String name;
  final String tag;
  final String type;
  final NotificareNotification? notification;

  NotificareScannable({
    required this.id,
    required this.name,
    required this.tag,
    required this.type,
    required this.notification,
  });

  factory NotificareScannable.fromJson(Map<String, dynamic> json) =>
      _$NotificareScannableFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareScannableToJson(this);
}
