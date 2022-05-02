import 'package:json_annotation/json_annotation.dart';
import 'package:notificare_flutter/src/converters/notificare_iso_date_time_converter.dart';
import 'package:notificare_flutter/src/models/notificare_do_not_disturb.dart';

part 'notificare_device.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@NotificareIsoDateTimeConverter()
class NotificareDevice {
  final String id;
  final String? userId;
  final String? userName;
  final double timeZoneOffset;
  final String osVersion;
  final String sdkVersion;
  final String appVersion;
  final String deviceString;
  final String language;
  final String region;
  final String transport;
  final NotificareDoNotDisturb? dnd;
  final Map<String, String> userData;
  final DateTime lastRegistered;

  NotificareDevice({
    required this.id,
    this.userId,
    this.userName,
    required this.timeZoneOffset,
    required this.osVersion,
    required this.sdkVersion,
    required this.appVersion,
    required this.deviceString,
    required this.language,
    required this.region,
    required this.transport,
    this.dnd,
    required this.userData,
    required this.lastRegistered,
  });

  factory NotificareDevice.fromJson(Map<String, dynamic> json) => _$NotificareDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareDeviceToJson(this);
}
