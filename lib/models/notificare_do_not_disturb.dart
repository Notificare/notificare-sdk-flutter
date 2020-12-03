import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'notificare_time.dart';

part 'notificare_do_not_disturb.g.dart';

@JsonSerializable(
  explicitToJson: true,
  anyMap: true,
)
class NotificareDoNotDisturb {
  final NotificareTime start;
  final NotificareTime end;

  NotificareDoNotDisturb({@required this.start, @required this.end}) {
    if (start == null) throw ArgumentError.notNull('start');
    if (end == null) throw ArgumentError.notNull('end');
  }

  factory NotificareDoNotDisturb.fromJson(Map<String, dynamic> json) => _$NotificareDoNotDisturbFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareDoNotDisturbToJson(this);
}
