import 'package:json_annotation/json_annotation.dart';

part 'notificare_dynamic_link.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class NotificareDynamicLink {
  final String target;

  NotificareDynamicLink({
    required this.target,
  });

  factory NotificareDynamicLink.fromJson(Map<String, dynamic> json) => _$NotificareDynamicLinkFromJson(json);

  Map<String, dynamic> toJson() => _$NotificareDynamicLinkToJson(this);
}
