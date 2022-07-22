// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_purchase_failed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificarePurchaseFailedEvent _$NotificarePurchaseFailedEventFromJson(
        Map json) =>
    NotificarePurchaseFailedEvent(
      code: json['code'] as int?,
      message: json['message'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$NotificarePurchaseFailedEventToJson(
        NotificarePurchaseFailedEvent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'errorMessage': instance.errorMessage,
    };
