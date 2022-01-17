// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareVisit _$NotificareVisitFromJson(Map json) => NotificareVisit(
      departureDate: const NotificareIsoDateTimeConverter()
          .fromJson(json['departureDate'] as String),
      arrivalDate: const NotificareIsoDateTimeConverter()
          .fromJson(json['arrivalDate'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$NotificareVisitToJson(NotificareVisit instance) =>
    <String, dynamic>{
      'departureDate':
          const NotificareIsoDateTimeConverter().toJson(instance.departureDate),
      'arrivalDate':
          const NotificareIsoDateTimeConverter().toJson(instance.arrivalDate),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
