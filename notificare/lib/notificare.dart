import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/models/notificare_application.dart';
import 'package:notificare/models/notificare_device.dart';
import 'package:notificare/models/notificare_notification.dart';

import 'modules/notificare_device_manager.dart';

class Notificare {
  // Channels
  static const MethodChannel _channel = const MethodChannel('re.notifica.flutter/notificare', JSONMethodCodec());

  // Events
  static Map<String, EventChannel> _eventChannels = new Map();
  static Map<String, Stream<dynamic>> _eventStreams = new Map();

  // Modules
  static final deviceManager = NotificareDeviceManager(_channel);

  static Future<bool> get isConfigured async {
    return await _channel.invokeMethod('isConfigured');
  }

  static Future<bool> get isReady async {
    return await _channel.invokeMethod('isReady');
  }

  static Future<bool> get useAdvancedLogging async {
    return await _channel.invokeMethod('getUseAdvancedLogging');
  }

  static Future<NotificareApplication?> get application async {
    final json = await _channel.invokeMapMethod<String, dynamic>('getApplication');
    return json != null ? NotificareApplication.fromJson(json) : null;
  }

  static Future<void> setUseAdvancedLogging(bool useAdvancedLogging) async {
    return await _channel.invokeMethod('setUseAdvancedLogging', useAdvancedLogging);
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
    await _channel.invokeMethod('launch');
  }

  static Future<void> unlaunch() async {
    await _channel.invokeMethod('unlaunch');
  }

  static Future<NotificareApplication> fetchApplication() async {
    final json = await _channel.invokeMapMethod<String, dynamic>('fetchApplication');
    return NotificareApplication.fromJson(json!);
  }

  static Future<NotificareNotification> fetchNotification(String id) async {
    final json = await _channel.invokeMapMethod<String, dynamic>('fetchNotification', id);
    return NotificareNotification.fromJson(json!);
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<NotificareApplication> get onReady {
    return _getEventStream('ready').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareApplication.fromJson(json.cast());
    });
  }

  static Stream<NotificareDevice> get onDeviceRegistered {
    return _getEventStream('device_registered').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareDevice.fromJson(json.cast());
    });
  }
}