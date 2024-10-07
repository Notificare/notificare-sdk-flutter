import 'package:json_annotation/json_annotation.dart';

part 'notificare_transport.g.dart';

@JsonEnum(alwaysCreate: true)
enum NotificareTransport {
  @JsonValue('Notificare')
  notificare,

  @JsonValue('GCM')
  gcm,

  @JsonValue('APNS')
  apns;

  factory NotificareTransport.fromJson(String json) =>
      _$NotificareTransportEnumMap.entries
          .firstWhere((element) => element.value == json)
          .key;
}
