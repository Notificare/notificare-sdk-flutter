import 'package:json_annotation/json_annotation.dart';

part 'notificare_region.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareRegion {
  final String id;
  final String name;
  final String? description;
  final String? referenceKey;
  final NotificareRegionGeometry geometry;
  final NotificareRegionAdvancedGeometry? advancedGeometry;
  final int? major;
  final double distance;
  final String timeZone;
  final double timeZoneOffset;

  NotificareRegion({
    required this.id,
    required this.name,
    required this.description,
    required this.referenceKey,
    required this.geometry,
    required this.advancedGeometry,
    required this.major,
    required this.distance,
    required this.timeZone,
    required this.timeZoneOffset,
  });

  factory NotificareRegion.fromJson(Map<String, dynamic> json) =>
      _$NotificareRegionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareRegionToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareRegionGeometry {
  final String type;
  final NotificareRegionCoordinate coordinate;

  NotificareRegionGeometry({
    required this.type,
    required this.coordinate,
  });

  factory NotificareRegionGeometry.fromJson(Map<String, dynamic> json) =>
      _$NotificareRegionGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareRegionGeometryToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareRegionAdvancedGeometry {
  final String type;
  final List<NotificareRegionCoordinate> coordinates;

  NotificareRegionAdvancedGeometry({
    required this.type,
    required this.coordinates,
  });

  factory NotificareRegionAdvancedGeometry.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NotificareRegionAdvancedGeometryFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NotificareRegionAdvancedGeometryToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareRegionCoordinate {
  final double latitude;
  final double longitude;

  NotificareRegionCoordinate({
    required this.latitude,
    required this.longitude,
  });

  factory NotificareRegionCoordinate.fromJson(Map<String, dynamic> json) =>
      _$NotificareRegionCoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareRegionCoordinateToJson(this);
}
