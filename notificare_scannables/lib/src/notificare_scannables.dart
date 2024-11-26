import 'package:flutter/services.dart';
import 'package:notificare_scannables/src/models/notificare_scannable.dart';

class NotificareScannables {
  NotificareScannables._();

  static const MethodChannel _channel = MethodChannel(
    're.notifica.scannables.flutter/notificare_scannables',
    JSONMethodCodec(),
  );

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  // Methods

  /// Indicates whether an NFC scannable session can be started on the current device.
  ///
  /// Returns `true` if the device supports NFC scanning, otherwise `false`.
  static Future<bool> get canStartNfcScannableSession async {
    return await _channel.invokeMethod('canStartNfcScannableSession');
  }

  /// Starts a scannable session, automatically selecting the best scanning method
  /// available.
  ///
  /// If NFC is available, it starts an NFC-based scanning session. If NFC is not
  /// available, it defaults to starting a QR code scanning session.
  static Future<void> startScannableSession() async {
    await _channel.invokeMethod('startScannableSession');
  }

  /// Starts an NFC scannable session.
  ///
  /// Initiates an NFC-based scan, allowing the user to scan NFC tags. This will
  /// only function on devices that support NFC and have it enabled.
  static Future<void> startNfcScannableSession() async {
    await _channel.invokeMethod('startNfcScannableSession');
  }

  /// Starts a QR code scannable session.
  ///
  /// Initiates a QR code-based scan using the device camera, allowing the user
  /// to scan QR codes.
  static Future<void> startQrCodeScannableSession() async {
    await _channel.invokeMethod('startQrCodeScannableSession');
  }

  /// Fetches a scannable item by its tag.
  ///
  /// - `tag`: The tag identifier for the scannable item to be fetched.
  /// Return the [NotificareScannable] object corresponding to the provided tag.
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
      _eventStreams[eventType] =
          _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  /// Called when a scannable item is detected during a scannable session.
  ///
  /// This method is triggered when either an NFC tag or a QR code is successfully
  /// scanned, and the corresponding [NotificareScannable] is retrieved. This
  /// callback will be invoked on the main thread.
  ///
  /// It will provide the detected [NotificareScannable].
  static Stream<NotificareScannable> get onScannableDetected {
    return _getEventStream('scannable_detected').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareScannable.fromJson(json.cast());
    });
  }

  /// Called when an error occurs during a scannable session.
  ///
  /// This method is triggered if there's a failure while scanning or processing
  /// the scannable item, either due to NFC or QR code scanning issues, or if the
  /// scannable item cannot be retrieved. This callback will be invoked on the
  /// main thread.
  ///
  /// It will provide the error that caused the session to fail, if it exists.
  static Stream<String?> get onScannableSessionFailed {
    return _getEventStream('scannable_session_failed').map((result) {
      return result;
    });
  }
}
