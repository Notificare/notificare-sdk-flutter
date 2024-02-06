import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

import '../models/notificare_notification_delivery_mechanism.dart';

part 'notificare_notification_received_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareNotificationReceivedEvent {
  final NotificareNotification notification;
  final NotificareNotificationDeliveryMechanism deliveryMechanism;

  NotificareNotificationReceivedEvent({
    required this.notification,
    required this.deliveryMechanism,
  });

  factory NotificareNotificationReceivedEvent.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NotificareNotificationReceivedEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NotificareNotificationReceivedEventToJson(this);
}
