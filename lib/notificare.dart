import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/models/notificare_device.dart';

import 'modules/notificare_device_manager.dart';

class Notificare {
  // Channels
  static const MethodChannel _channel = const MethodChannel('re.notifica.flutter/notificare');
  static const MethodChannel _deviceManagerChannel =
      const MethodChannel('re.notifica.flutter/notificare/device-manager', );

  // Events
  static Map<String, EventChannel> _eventChannels = new Map();
  static Map<String, Stream<dynamic>> _eventStreams = new Map();

  // Modules
  static final deviceManager = NotificareDeviceManager(_deviceManagerChannel);

  static Future<bool> get isConfigured async {
    return await (_channel.invokeMethod('isConfigured') as FutureOr<bool>);
  }

  static Future<bool> get isReady async {
    return await (_channel.invokeMethod('isReady') as FutureOr<bool>);
  }

  static Future<void> configure(String applicationKey, String applicationSecret) async {
    await _channel.invokeMethod(
      'configure',
      {
        'applicationKey': applicationKey,
        'applicationSecret': applicationSecret,
      },
    );
  }

  static Future<void> launch() async {
    await _channel.invokeMethod('launch', null);
  }

  static Future<void> unlaunch() async {
    await _channel.invokeMethod('unlaunch');
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name);
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<void> get onReady {
    return _getEventStream('ready');
  }

  static Stream<NotificareDevice> get onDeviceRegistered {
    return _getEventStream('device_registered').map((json) => NotificareDevice.fromJson(json));
  }
}
