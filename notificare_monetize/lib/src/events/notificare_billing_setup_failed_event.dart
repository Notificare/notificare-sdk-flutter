import 'package:json_annotation/json_annotation.dart';

part 'notificare_billing_setup_failed_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareBillingSetupFailedEvent {
  final int code;
  final String message;

  NotificareBillingSetupFailedEvent({
    required this.code,
    required this.message,
  });

  factory NotificareBillingSetupFailedEvent.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NotificareBillingSetupFailedEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NotificareBillingSetupFailedEventToJson(this);
}
