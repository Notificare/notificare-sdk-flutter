// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareRegion _$NotificareRegionFromJson(Map json) {
  return NotificareRegion(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    referenceKey: json['referenceKey'] as String?,
    geometry: NotificareRegionGeometry.fromJson(
        Map<String, dynamic>.from(json['geometry'] as Map)),
    advancedGeometry: json['advancedGeometry'] == null
        ? null
        : NotificareRegionAdvancedGeometry.fromJson(
            Map<String, dynamic>.from(json['advancedGeometry'] as Map)),
    major: json['major'] as int?,
    distance: (json['distance'] as num).toDouble(),
    timeZone: json['timeZone'] as String,
    timeZoneOffset: json['timeZoneOffset'] as int,
  );
}

Map<String, dynamic> _$NotificareRegionToJson(NotificareRegion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'referenceKey': instance.referenceKey,
      'geometry': instance.geometry.toJson(),
      'advancedGeometry': instance.advancedGeometry?.toJson(),
      'major': instance.major,
      'distance': instance.distance,
      'timeZone': instance.timeZone,
      'timeZoneOffset': instance.timeZoneOffset,
    };

NotificareRegionGeometry _$NotificareRegionGeometryFromJson(Map json) {
  return NotificareRegionGeometry(
    type: json['type'] as String,
    coordinate: NotificareRegionCoordinate.fromJson(
        Map<String, dynamic>.from(json['coordinate'] as Map)),
  );
}

Map<String, dynamic> _$NotificareRegionGeometryToJson(
        NotificareRegionGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinate': instance.coordinate.toJson(),
    };

NotificareRegionAdvancedGeometry _$NotificareRegionAdvancedGeometryFromJson(
    Map json) {
  return NotificareRegionAdvancedGeometry(
    type: json['type'] as String,
    coordinates: (json['coordinates'] as List<dynamic>)
        .map((e) => NotificareRegionCoordinate.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}

Map<String, dynamic> _$NotificareRegionAdvancedGeometryToJson(
        NotificareRegionAdvancedGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates.map((e) => e.toJson()).toList(),
    };

NotificareRegionCoordinate _$NotificareRegionCoordinateFromJson(Map json) {
  return NotificareRegionCoordinate(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _$NotificareRegionCoordinateToJson(
        NotificareRegionCoordinate instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
