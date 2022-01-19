import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/src/models/notificare_application.dart';
import 'package:notificare/src/models/notificare_device.dart';
import 'package:notificare/src/models/notificare_notification.dart';
import 'package:notificare/src/notificare_device_module.dart';
import 'package:notificare/src/notificare_events_module.dart';

class Notificare {
  Notificare._();

  // Channels
  static const MethodChannel _channel = MethodChannel('re.notifica.flutter/notificare', JSONMethodCodec());

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  // Modules
  static final _device = NotificareDeviceModule(_channel);
  static final _events = NotificareEventsModule(_channel);

  static NotificareDeviceModule device() => _device;

  static NotificareEventsModule events() => _events;

  // Methods

  static Future<bool> get isConfigured async {
    return await _channel.invokeMethod('isConfigured');
  }

  static Future<bool> get isReady async {
    return await _channel.invokeMethod('isReady');
  }

  static Future<NotificareApplication?> get application async {
    final json = await _channel.invokeMapMethod<String, dynamic>('getApplication');
    return json != null ? NotificareApplication.fromJson(json) : null;
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

  static Stream<void> get onUnlaunched {
    return _getEventStream('unlaunched');
  }

  static Stream<NotificareDevice> get onDeviceRegistered {
    return _getEventStream('device_registered').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareDevice.fromJson(json.cast());
    });
  }

  static Stream<String> get onUrlOpened {
    return _getEventStream('url_opened').map((result) {
      return result as String;
    });
  }
}
