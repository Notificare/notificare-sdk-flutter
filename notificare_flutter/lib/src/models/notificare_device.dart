import 'package:json_annotation/json_annotation.dart';
import 'package:notificare_flutter/src/models/notificare_do_not_disturb.dart';

part 'notificare_device.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareDevice {
  final String id;
  final String? userId;
  final String? userName;
  final double timeZoneOffset;
  final NotificareDoNotDisturb? dnd;
  final Map<String, String> userData;

  NotificareDevice({
    required this.id,
    this.userId,
    this.userName,
    required this.timeZoneOffset,
    this.dnd,
    required this.userData,
  });

  factory NotificareDevice.fromJson(Map<String, dynamic> json) => _$NotificareDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareDeviceToJson(this);
}
