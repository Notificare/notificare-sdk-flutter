// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_action_executed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareActionExecutedEvent _$NotificareActionExecutedEventFromJson(
        Map json) =>
    NotificareActionExecutedEvent(
      message: NotificareInAppMessage.fromJson(
          Map<String, dynamic>.from(json['message'] as Map)),
      action: NotificareInAppMessageAction.fromJson(
          Map<String, dynamic>.from(json['action'] as Map)),
    );

Map<String, dynamic> _$NotificareActionExecutedEventToJson(
        NotificareActionExecutedEvent instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
      'action': instance.action.toJson(),
    };
