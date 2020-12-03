import 'package:json_annotation/json_annotation.dart';

class IsoDateTimeConverter implements JsonConverter<DateTime, String> {
  const IsoDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime json) => json.toUtc().toIso8601String();
}
