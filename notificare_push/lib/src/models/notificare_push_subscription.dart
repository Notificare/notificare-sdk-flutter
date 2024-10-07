import 'package:json_annotation/json_annotation.dart';

part 'notificare_push_subscription.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificarePushSubscription {
  final String? token;

  NotificarePushSubscription({required this.token});

  factory NotificarePushSubscription.fromJson(Map<String, dynamic> json) =>
      _$NotificarePushSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificarePushSubscriptionToJson(this);
}
