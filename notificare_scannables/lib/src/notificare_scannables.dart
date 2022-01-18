import 'package:flutter/services.dart';
import 'package:notificare_scannables/src/models/notificare_scannable.dart';

class NotificareScannables {
  NotificareScannables._();

  static const MethodChannel _channel =
      MethodChannel('re.notifica.scannables.flutter/notificare_scannables', JSONMethodCodec());

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  // Methods
  static Future<bool> get canStartNfcScannableSession async {
    return await _channel.invokeMethod('canStartNfcScannableSession');
  }

  static Future<void> startScannableSession() async {
    await _channel.invokeMethod('startScannableSession');
  }

  static Future<void> startNfcScannableSession() async {
    await _channel.invokeMethod('startNfcScannableSession');
  }

  static Future<void> startQrCodeScannableSession() async {
    await _channel.invokeMethod('startQrCodeScannableSession');
  }

  static Future<NotificareScannable> fetch({required String tag}) async {
    final json = await _channel.invokeMapMethod<String, dynamic>('fetch', tag);
    return NotificareScannable.fromJson(json!);
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.scannables.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, const JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<NotificareScannable> get onScannableDetected {
    return _getEventStream('scannable_detected').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareScannable.fromJson(json.cast());
    });
  }

  static Stream<String?> get onScannableSessionFailed {
    return _getEventStream('scannable_session_failed').map((result) {
      return result;
    });
  }
}
