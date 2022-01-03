// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_notification_url_clicked_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareNotificationUrlClickedEvent
    _$NotificareNotificationUrlClickedEventFromJson(Map json) =>
        NotificareNotificationUrlClickedEvent(
          notification: NotificareNotification.fromJson(
              Map<String, dynamic>.from(json['notification'] as Map)),
          url: json['url'] as String,
        );

Map<String, dynamic> _$NotificareNotificationUrlClickedEventToJson(
        NotificareNotificationUrlClickedEvent instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'url': instance.url,
    };
