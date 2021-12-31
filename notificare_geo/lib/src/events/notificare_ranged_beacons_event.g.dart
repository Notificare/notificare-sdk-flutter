// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_ranged_beacons_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareRangedBeaconsEvent _$NotificareRangedBeaconsEventFromJson(Map json) =>
    NotificareRangedBeaconsEvent(
      region: NotificareRegion.fromJson(
          Map<String, dynamic>.from(json['region'] as Map)),
      beacons: (json['beacons'] as List<dynamic>)
          .map((e) =>
              NotificareBeacon.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$NotificareRangedBeaconsEventToJson(
        NotificareRangedBeaconsEvent instance) =>
    <String, dynamic>{
      'region': instance.region.toJson(),
      'beacons': instance.beacons.map((e) => e.toJson()).toList(),
    };
