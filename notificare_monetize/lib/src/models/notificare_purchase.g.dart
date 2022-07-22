// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificarePurchase _$NotificarePurchaseFromJson(Map json) => NotificarePurchase(
      id: json['id'] as String,
      productIdentifier: json['productIdentifier'] as String,
      time: const NotificareIsoDateTimeConverter()
          .fromJson(json['time'] as String),
      originalJson: json['originalJson'] as String?,
      packageName: json['packageName'] as String?,
      token: json['token'] as String?,
      signature: json['signature'] as String?,
      isAcknowledged: json['isAcknowledged'] as bool?,
      receipt: json['receipt'] as String?,
    );

Map<String, dynamic> _$NotificarePurchaseToJson(NotificarePurchase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productIdentifier': instance.productIdentifier,
      'time': const NotificareIsoDateTimeConverter().toJson(instance.time),
      'originalJson': instance.originalJson,
      'packageName': instance.packageName,
      'token': instance.token,
      'signature': instance.signature,
      'isAcknowledged': instance.isAcknowledged,
      'receipt': instance.receipt,
    };
