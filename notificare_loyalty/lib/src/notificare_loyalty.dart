import 'package:flutter/services.dart';
import 'package:notificare_loyalty/src/models/notificare_pass.dart';

class NotificareLoyalty {
  NotificareLoyalty._();

  static const MethodChannel _channel = MethodChannel(
    're.notifica.loyalty.flutter/notificare_loyalty',
    JSONMethodCodec(),
  );

  // Methods

  /// Fetches a pass by its serial number.
  ///
  /// - `serial`: The serial number of the pass to be fetched.
  /// 
  /// Returns the fetched [NotificarePass] corresponding to the given serial
  /// number.
  static Future<NotificarePass> fetchPassBySerial(String serial) async {
    final json = await _channel.invokeMapMethod<String, dynamic>(
      'fetchPassBySerial',
      serial,
    );
    return NotificarePass.fromJson(json!);
  }

  /// Fetches a pass by its barcode.
  ///
  /// - `barcode`: The barcode of the pass to be fetched.
  /// 
  /// Returns the fetched [NotificarePass] corresponding to the given
  /// barcode.
  static Future<NotificarePass> fetchPassByBarcode(String barcode) async {
    final json = await _channel.invokeMapMethod<String, dynamic>(
      'fetchPassByBarcode',
      barcode,
    );
    return NotificarePass.fromJson(json!);
  }

  /// Presents a pass to the user.
  ///
  ///- `pass`: The [NotificarePass] to be presented to the user.
  static Future<void> present({required NotificarePass pass}) async {
    await _channel.invokeMethod('present', pass.toJson());
  }
}
