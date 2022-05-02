import 'package:json_annotation/json_annotation.dart';

class NotificareNullableIsoDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const NotificareNullableIsoDateTimeConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;
    return DateTime.parse(json).toLocal();
  }

  @override
  String? toJson(DateTime? json) => json?.toUtc().toIso8601String();
}
