// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificarePass _$NotificarePassFromJson(Map json) {
  return NotificarePass(
    id: json['id'] as String,
    type: json['type'] as String?,
    version: json['version'] as int,
    passbook: json['passbook'] as String?,
    template: json['template'] as String?,
    serial: json['serial'] as String,
    barcode: json['barcode'] as String,
    redeem: json['redeem'] as String,
    redeemHistory: (json['redeemHistory'] as List<dynamic>)
        .map((e) => NotificarePassRedemption.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList(),
    limit: json['limit'] as int,
    token: json['token'] as String,
    data: Map<String, dynamic>.from(json['data'] as Map),
    date: const IsoDateTimeConverter().fromJson(json['date'] as String),
    googlePaySaveLink: json['googlePaySaveLink'] as String?,
  );
}

Map<String, dynamic> _$NotificarePassToJson(NotificarePass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'version': instance.version,
      'passbook': instance.passbook,
      'template': instance.template,
      'serial': instance.serial,
      'barcode': instance.barcode,
      'redeem': instance.redeem,
      'redeemHistory': instance.redeemHistory.map((e) => e.toJson()).toList(),
      'limit': instance.limit,
      'token': instance.token,
      'data': instance.data,
      'date': const IsoDateTimeConverter().toJson(instance.date),
      'googlePaySaveLink': instance.googlePaySaveLink,
    };

NotificarePassRedemption _$NotificarePassRedemptionFromJson(Map json) {
  return NotificarePassRedemption(
    comments: json['comments'] as String?,
    date: const IsoDateTimeConverter().fromJson(json['date'] as String),
  );
}

Map<String, dynamic> _$NotificarePassRedemptionToJson(
        NotificarePassRedemption instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'date': const IsoDateTimeConverter().toJson(instance.date),
    };
