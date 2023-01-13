import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/notificare.dart';

part 'notificare_purchase.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@NotificareIsoDateTimeConverter()
class NotificarePurchase {
  final String id;
  final String productIdentifier;
  final DateTime time;

  // Android-specific properties
  final String? originalJson;
  final String? packageName;
  final String? token;
  final String? signature;
  final bool? isAcknowledged;

  // iOS-specific properties
  final String? receipt;

  NotificarePurchase({
    required this.id,
    required this.productIdentifier,
    required this.time,
    this.originalJson,
    this.packageName,
    this.token,
    this.signature,
    this.isAcknowledged,
    this.receipt,
  });

  factory NotificarePurchase.fromJson(Map<String, dynamic> json) => _$NotificarePurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificarePurchaseToJson(this);
}
