import 'package:json_annotation/json_annotation.dart';

import 'notificare_time.dart';

part 'notificare_do_not_disturb.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareDoNotDisturb {
  final NotificareTime start;
  final NotificareTime end;

  NotificareDoNotDisturb({
    required this.start,
    required this.end,
  });

  factory NotificareDoNotDisturb.fromJson(Map<String, dynamic> json) => _$NotificareDoNotDisturbFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareDoNotDisturbToJson(this);
}
