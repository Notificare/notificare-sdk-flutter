// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_notification_received_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareNotificationReceivedEvent
    _$NotificareNotificationReceivedEventFromJson(Map json) =>
        NotificareNotificationReceivedEvent(
          notification: NotificareNotification.fromJson(
              Map<String, dynamic>.from(json['notification'] as Map)),
          deliveryMechanism: $enumDecode(
              _$NotificareNotificationDeliveryMechanismEnumMap,
              json['deliveryMechanism']),
        );

Map<String, dynamic> _$NotificareNotificationReceivedEventToJson(
        NotificareNotificationReceivedEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'deliveryMechanism': _$NotificareNotificationDeliveryMechanismEnumMap[
          instance.deliveryMechanism]!,
    };

const _$NotificareNotificationDeliveryMechanismEnumMap = {
  NotificareNotificationDeliveryMechanism.standard: 'standard',
  NotificareNotificationDeliveryMechanism.silent: 'silent',
};
