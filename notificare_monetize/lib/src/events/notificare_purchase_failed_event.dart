import 'package:json_annotation/json_annotation.dart';

part 'notificare_purchase_failed_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificarePurchaseFailedEvent {
  // Android-specific properties
  final int? code;
  final String? message;

  // iOS-specific properties
  final String? errorMessage;

  NotificarePurchaseFailedEvent({
    this.code,
    this.message,
    this.errorMessage,
  });

  factory NotificarePurchaseFailedEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificarePurchaseFailedEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificarePurchaseFailedEventToJson(this);
}
