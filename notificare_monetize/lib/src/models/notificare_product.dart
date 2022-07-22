import 'package:json_annotation/json_annotation.dart';

part 'notificare_product.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareProduct {
  final String id;
  final String identifier;
  final String name;
  final String type;
  final NotificareProductStoreDetails? storeDetails;

  NotificareProduct({
    required this.id,
    required this.identifier,
    required this.name,
    required this.type,
    this.storeDetails,
  });

  factory NotificareProduct.fromJson(Map<String, dynamic> json) => _$NotificareProductFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareProductToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareProductStoreDetails {
  final String? name;
  final String title;
  final String description;
  final double price;
  final String currencyCode;

  NotificareProductStoreDetails({
    this.name,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
  });

  factory NotificareProductStoreDetails.fromJson(Map<String, dynamic> json) =>
      _$NotificareProductStoreDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareProductStoreDetailsToJson(this);
}
