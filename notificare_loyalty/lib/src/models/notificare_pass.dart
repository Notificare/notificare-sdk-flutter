import 'package:json_annotation/json_annotation.dart';
import 'package:notificare/converters/iso_date_time_converter.dart';

part 'notificare_pass.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@IsoDateTimeConverter()
class NotificarePass {
  final String id;
  final String? type;
  final int version;
  final String? passbook;
  final String? template;
  final String serial;
  final String barcode;
  final String redeem;
  final List<NotificarePassRedemption> redeemHistory;
  final int limit;
  final String token;
  final Map<String, dynamic> data;
  final DateTime date;
  final String? googlePaySaveLink;

  NotificarePass({
    required this.id,
    required this.type,
    required this.version,
    required this.passbook,
    required this.template,
    required this.serial,
    required this.barcode,
    required this.redeem,
    required this.redeemHistory,
    required this.limit,
    required this.token,
    required this.data,
    required this.date,
    required this.googlePaySaveLink,
  });

  factory NotificarePass.fromJson(Map<String, dynamic> json) => _$NotificarePassFromJson(json);

  Map<String, dynamic> toJson() => _$NotificarePassToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
@IsoDateTimeConverter()
class NotificarePassRedemption {
  final String? comments;
  final DateTime date;

  NotificarePassRedemption({
    required this.comments,
    required this.date,
  });

  factory NotificarePassRedemption.fromJson(Map<String, dynamic> json) => _$NotificarePassRedemptionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificarePassRedemptionToJson(this);
}
