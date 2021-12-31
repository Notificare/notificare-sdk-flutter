import 'package:json_annotation/json_annotation.dart';
import 'package:notificare_geo/src/models/notificare_beacon.dart';
import 'package:notificare_geo/src/models/notificare_region.dart';

part 'notificare_ranged_beacons_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareRangedBeaconsEvent {
  final NotificareRegion region;
  final List<NotificareBeacon> beacons;

  NotificareRangedBeaconsEvent({
    required this.region,
    required this.beacons,
  });

  factory NotificareRangedBeaconsEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificareRangedBeaconsEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareRangedBeaconsEventToJson(this);
}
