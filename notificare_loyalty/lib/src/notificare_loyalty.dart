import 'package:flutter/services.dart';
import 'package:notificare_loyalty/src/models/notificare_pass.dart';

class NotificareLoyalty {
  NotificareLoyalty._();

  static const MethodChannel _channel = MethodChannel(
    're.notifica.loyalty.flutter/notificare_loyalty',
    JSONMethodCodec(),
  );

  // Methods
  static Future<NotificarePass> fetchPassBySerial(String serial) async {
    final json = await _channel.invokeMapMethod<String, dynamic>(
      'fetchPassBySerial',
      serial,
    );
    return NotificarePass.fromJson(json!);
  }

  static Future<NotificarePass> fetchPassByBarcode(String barcode) async {
    final json = await _channel.invokeMapMethod<String, dynamic>(
      'fetchPassByBarcode',
      barcode,
    );
    return NotificarePass.fromJson(json!);
  }

  static Future<void> present({required NotificarePass pass}) async {
    await _channel.invokeMethod('present', pass.toJson());
  }
}
