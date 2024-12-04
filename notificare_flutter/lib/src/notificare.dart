import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare_flutter/src/models/notificare_application.dart';
import 'package:notificare_flutter/src/models/notificare_device.dart';
import 'package:notificare_flutter/src/models/notificare_dynamic_link.dart';
import 'package:notificare_flutter/src/models/notificare_notification.dart';
import 'package:notificare_flutter/src/notificare_device_module.dart';
import 'package:notificare_flutter/src/notificare_events_module.dart';

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

  /// Indicates whether Notificare has been configured.
  ///
  /// Returns `true` if Notificare is successfully configured, and `false`
  /// otherwise.
  static Future<bool> get isConfigured async {
    return await _channel.invokeMethod('isConfigured');
  }

  /// Indicates whether Notificare is ready.
  ///
  /// Returns `true` once the SDK has completed the initialization process and
  /// is ready for use.
  static Future<bool> get isReady async {
    return await _channel.invokeMethod('isReady');
  }

  /// Provides the current application metadata, if available.
  ///
  /// Returns the [NotificareApplication] object representing the configured
  /// application, or `null` if the application is not yet available.
  static Future<NotificareApplication?> get application async {
    final json = await _channel.invokeMapMethod<String, dynamic>('getApplication');
    return json != null ? NotificareApplication.fromJson(json) : null;
  }

  /// Launches the Notificare SDK, and all the additional available modules,
  /// preparing them for use.
  static Future<void> launch() async {
    await _channel.invokeMethod('launch');
  }

  /// Unlaunches the Notificare SDK.
  ///
  /// This method shuts down the SDK, removing all data, both locally and remotely
  /// in the servers. It destroys all the device's data permanently.
  static Future<void> unlaunch() async {
    await _channel.invokeMethod('unlaunch');
  }

  /// Fetches the application metadata.
  ///
  /// Returns the [NotificareApplication] metadata.
  static Future<NotificareApplication> fetchApplication() async {
    final json = await _channel.invokeMapMethod<String, dynamic>('fetchApplication');
    return NotificareApplication.fromJson(json!);
  }

  /// Fetches a [NotificareNotification] by its ID.
  ///
  /// - `id`: The ID of the notification to fetch.
  ///
  /// Returns the [NotificareNotification] object associated with the
  /// provided ID.
  static Future<NotificareNotification> fetchNotification(String id) async {
    final json = await _channel.invokeMapMethod<String, dynamic>('fetchNotification', id);
    return NotificareNotification.fromJson(json!);
  }

  /// Fetches a [NotificareDynamicLink] from a URL.
  ///
  /// - `url`: The URL to fetch the dynamic link from.
  ///
  /// Returns the [NotificareDynamicLink] object.
  static Future<NotificareDynamicLink> fetchDynamicLink(String url) async {
    final json = await _channel.invokeMapMethod<String, dynamic>('fetchDynamicLink', url);
    return NotificareDynamicLink.fromJson(json!);
  }

  /// Checks if a deferred link exists and can be evaluated.
  ///
  /// Returns `true` if a deferred link can be evaluated, `false` otherwise.
  static Future<bool> get canEvaluateDeferredLink async {
    return await _channel.invokeMethod('canEvaluateDeferredLink');
  }

  /// Evaluates the deferred link. Once the deferred link is evaluated,
  /// Notificare will open the resolved deep link.
  ///
  /// Returns `true` if the deferred link was successfully evaluated, `false`
  /// otherwise.
  static Future<bool> evaluateDeferredLink() async {
    return await _channel.invokeMethod('evaluateDeferredLink');
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, const JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  /// Called when the Notificare SDK is fully ready and the application metadata
  /// is available.
  ///
  /// This method is invoked after the SDK has been successfully launched and is
  /// available for use.
  ///
  /// It will provide the [NotificareApplication] object containing
  /// the application's metadata.
  static Stream<NotificareApplication> get onReady {
    return _getEventStream('ready').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareApplication.fromJson(json.cast());
    });
  }

  /// Called when the Notificare SDK has been unlaunched.
  ///
  /// This method is invoked after the SDK has been shut down (unlaunched) and
  /// is no longer in use.
  static Stream<void> get onUnlaunched {
    return _getEventStream('unlaunched');
  }

  /// Called when the device has been successfully registered with the Notificare
  /// platform.
  ///
  /// This method is triggered after the device is initially created, which
  /// happens the first time `launch()` is called.
  /// Once created, the method will not trigger again unless the device is
  /// deleted by calling `unlaunch()` and created again on a new `launch()`.
  ///
  /// It will provide the registered [NotificareDevice] instance representing
  /// the device's registration details.
  static Stream<NotificareDevice> get onDeviceRegistered {
    return _getEventStream('device_registered').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareDevice.fromJson(json.cast());
    });
  }

  /// Called when the device opens a URL.
  ///
  /// This method is invoked when the device opens a URL.
  /// 
  /// It will provide the opened URL.
  static Stream<String> get onUrlOpened {
    return _getEventStream('url_opened').map((result) {
      return result as String;
    });
  }
}
