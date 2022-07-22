// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareProduct _$NotificareProductFromJson(Map json) => NotificareProduct(
      id: json['id'] as String,
      identifier: json['identifier'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      storeDetails: json['storeDetails'] == null
          ? null
          : NotificareProductStoreDetails.fromJson(
              Map<String, dynamic>.from(json['storeDetails'] as Map)),
    );

Map<String, dynamic> _$NotificareProductToJson(NotificareProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'identifier': instance.identifier,
      'name': instance.name,
      'type': instance.type,
      'storeDetails': instance.storeDetails?.toJson(),
    };

NotificareProductStoreDetails _$NotificareProductStoreDetailsFromJson(
        Map json) =>
    NotificareProductStoreDetails(
      name: json['name'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
    );

Map<String, dynamic> _$NotificareProductStoreDetailsToJson(
        NotificareProductStoreDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'currencyCode': instance.currencyCode,
    };
