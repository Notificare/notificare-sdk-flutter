import 'dart:ui';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:notificare_geo/src/events/notificare_ranged_beacons_event.dart';
import 'package:notificare_geo/src/models/notificare_beacon.dart';
import 'package:notificare_geo/src/models/notificare_heading.dart';
import 'package:notificare_geo/src/models/notificare_location.dart';
import 'package:notificare_geo/src/models/notificare_region.dart';
import 'package:notificare_geo/src/models/notificare_visit.dart';

import 'callback_dispatcher.dart';

class NotificareGeo {
  NotificareGeo._();

  static const MethodChannel _channel = MethodChannel(
    're.notifica.geo.flutter/notificare_geo',
    JSONMethodCodec(),
  );

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  // Methods
  static Future<bool> get hasLocationServicesEnabled async {
    return await _channel.invokeMethod('hasLocationServicesEnabled');
  }

  static Future<bool> get hasBluetoothEnabled async {
    return await _channel.invokeMethod('hasBluetoothEnabled');
  }

  static Future<List<NotificareRegion>> get monitoredRegions async {
    final json = await _channel
        .invokeListMethod<Map<String, dynamic>>('getMonitoredRegions');
    return json!.map((e) => NotificareRegion.fromJson(e)).toList();
  }

  static Future<List<NotificareRegion>> get enteredRegions async {
    final json = await _channel
        .invokeListMethod<Map<String, dynamic>>('getEnteredRegions');
    return json!.map((e) => NotificareRegion.fromJson(e)).toList();
  }

  static Future<void> enableLocationUpdates() async {
    await _channel.invokeMethod('enableLocationUpdates');
  }

  static Future<void> disableLocationUpdates() async {
    await _channel.invokeMethod('disableLocationUpdates');
  }

  // Background callback methods

  static Future<void> setLocationUpdatedBackgroundCallback(
      void Function(NotificareLocation location) onLocationUpdated) async {
    if (!Platform.isAndroid) {
      return;
    }

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(onLocationUpdated);

    if (dispatcher == null || callback == null) {
      debugPrint(
          "Failed to register onLocationUpdatedCallback. Ensure you are using a static or top level function.");

      return;
    }

    await _channel.invokeListMethod("setLocationUpdatedBackgroundCallback", {
      "callbackDispatcher": dispatcher.toRawHandle(),
      "callback": callback.toRawHandle()
    });
  }

  static Future<void> setRegionEnteredBackgroundCallback(
      void Function(NotificareRegion region) onRegionEntered) async {
    if (!Platform.isAndroid) {
      return;
    }

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(onRegionEntered);

    if (dispatcher == null || callback == null) {
      debugPrint(
          "Failed to register onRegionEnteredCallback. Ensure you are using a static or top level function.");
      return;
    }

    await _channel.invokeListMethod("setRegionEnteredBackgroundCallback", {
      "callbackDispatcher": dispatcher.toRawHandle(),
      "callback": callback.toRawHandle()
    });
  }

  static Future<void> setRegionExitedBackgroundCallback(
      void Function(NotificareRegion region) onRegionExited) async {
    if (!Platform.isAndroid) {
      return;
    }

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(onRegionExited);

    if (dispatcher == null || callback == null) {
      debugPrint(
          "Failed to register onRegionExitedCallback. Ensure you are using a static or top level function.");
      return;
    }

    await _channel.invokeListMethod("setRegionExitedBackgroundCallback", {
      "callbackDispatcher": dispatcher.toRawHandle(),
      "callback": callback.toRawHandle()
    });
  }

  static Future<void> setBeaconEnteredBackgroundCallback(
      void Function(NotificareBeacon beacon) onBeaconEntered) async {
    if (!Platform.isAndroid) {
      return;
    }

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(onBeaconEntered);

    if (dispatcher == null || callback == null) {
      debugPrint(
          "Failed to register onBeaconEnteredCallback. Ensure you are using a static or top level function.");
      return;
    }

    await _channel.invokeListMethod("setBeaconEnteredBackgroundCallback", {
      "callbackDispatcher": dispatcher.toRawHandle(),
      "callback": callback.toRawHandle()
    });
  }

  static Future<void> setBeaconExitedBackgroundCallback(
      void Function(NotificareBeacon beacon) onBeaconExited) async {
    if (!Platform.isAndroid) {
      return;
    }

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(onBeaconExited);

    if (dispatcher == null || callback == null) {
      debugPrint(
          "Failed to register onBeaconExitedCallback. Ensure you are using a static or top level function.");
      return;
    }

    await _channel.invokeListMethod("setBeaconExitedBackgroundCallback", {
      "callbackDispatcher": dispatcher.toRawHandle(),
      "callback": callback.toRawHandle()
    });
  }

  static Future<void> setBeaconsRangedBackgroundCallback(
      void Function(NotificareRangedBeaconsEvent event) onBeaconsRanged) async {
    if (!Platform.isAndroid) {
      return;
    }

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(onBeaconsRanged);

    if (dispatcher == null || callback == null) {
      debugPrint(
          "Failed to register onBeaconsRangedCallback. Ensure you are using a static or top level function.");
      return;
    }

    await _channel.invokeListMethod("setBeaconsRangedBackgroundCallback", {
      "callbackDispatcher": dispatcher.toRawHandle(),
      "callback": callback.toRawHandle()
    });
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.geo.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, const JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] =
          _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<NotificareLocation> get onLocationUpdated {
    return _getEventStream('location_updated').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareLocation.fromJson(json.cast());
    });
  }

  static Stream<NotificareRegion> get onRegionEntered {
    return _getEventStream('region_entered').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareRegion.fromJson(json.cast());
    });
  }

  static Stream<NotificareRegion> get onRegionExited {
    return _getEventStream('region_exited').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareRegion.fromJson(json.cast());
    });
  }

  static Stream<NotificareBeacon> get onBeaconEntered {
    return _getEventStream('beacon_entered').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareBeacon.fromJson(json.cast());
    });
  }

  static Stream<NotificareBeacon> get onBeaconExited {
    return _getEventStream('beacon_exited').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareBeacon.fromJson(json.cast());
    });
  }

  static Stream<NotificareRangedBeaconsEvent> get onBeaconsRanged {
    return _getEventStream('beacons_ranged').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareRangedBeaconsEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareVisit> get onVisit {
    return _getEventStream('visit').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareVisit.fromJson(json.cast());
    });
  }

  static Stream<NotificareHeading> get onHeadingUpdated {
    return _getEventStream('heading_updated').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareHeading.fromJson(json.cast());
    });
  }
}
