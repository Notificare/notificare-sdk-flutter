import 'package:json_annotation/json_annotation.dart';

enum NotificareNotificationDeliveryMechanism {
  @JsonValue("standard")
  standard,

  @JsonValue("silent")
  silent,
}
