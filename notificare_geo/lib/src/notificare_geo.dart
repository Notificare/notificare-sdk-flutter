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
  
  /// Indicates whether location services are enabled.
  ///
  /// Returns `true` if the location services are enabled by the application, and
  /// `false` otherwise.
  static Future<bool> get hasLocationServicesEnabled async {
    return await _channel.invokeMethod('hasLocationServicesEnabled');
  }

  /// Indicates whether Bluetooth is enabled.
  ///
  /// Returns `true` if Bluetooth is enabled and available for beacon detection
  /// and ranging, and `false` otherwise.
  static Future<bool> get hasBluetoothEnabled async {
    return await _channel.invokeMethod('hasBluetoothEnabled');
  }

  /// Provides a list of regions currently being monitored.
  ///
  /// Returns a list of [NotificareRegion] objects representing the geographical
  /// regions being actively monitored for entry and exit events.
  static Future<List<NotificareRegion>> get monitoredRegions async {
    final json = await _channel
        .invokeListMethod<Map<String, dynamic>>('getMonitoredRegions');
    return json!.map((e) => NotificareRegion.fromJson(e)).toList();
  }

  /// Provides a list of regions the user has entered.
  ///
  /// Returns a list of [NotificareRegion] objects representing the regions that
  /// the user has entered and not yet exited.
  static Future<List<NotificareRegion>> get enteredRegions async {
    final json = await _channel
        .invokeListMethod<Map<String, dynamic>>('getEnteredRegions');
    return json!.map((e) => NotificareRegion.fromJson(e)).toList();
  }

  /// Enables location updates, activating location tracking, region monitoring,
  /// and beacon detection.
  ///
  /// **Note**: This function requires explicit location permissions from the
  /// user. Starting with Android 10 (API level 29), background location access
  /// requires the ACCESS_BACKGROUND_LOCATION permission. For beacon detection,
  /// Bluetooth permissions are also necessary. Ensure all permissions are
  /// requested before invoking this method.
  ///
  /// The behavior varies based on granted permissions:
  /// - **Permission denied**: Clears the device's location information.
  /// - **When In Use permission granted**: Tracks location only while
  /// the app is in use.
  /// - **Always permission granted**: Enables geofencing
  /// capabilities.
  /// - **Always + Bluetooth permissions granted**: Enables
  /// geofencing and beacon detection.
  static Future<void> enableLocationUpdates() async {
    await _channel.invokeMethod('enableLocationUpdates');
  }

  /// Disables location updates.
  ///
  /// This method stops receiving location updates, monitoring regions, and
  /// detecting nearby beacons.
  static Future<void> disableLocationUpdates() async {
    await _channel.invokeMethod('disableLocationUpdates');
  }

  // Background callback methods

  /// Sets a callback that will be invoked when an onLocationUpdated event is
  /// triggered in the background.
  ///
  /// - `onLocationUpdated`: A callback that will be invoked with the result of
  /// the onLocationUpdated event, when in background. It will provide the updated
  /// [NotificareLocation] object representing the user's new location.
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

  /// Sets a callback that will be invoked when an onRegionEntered event is
  /// triggered in the background.
  ///
  /// - `onRegionEntered`: A callback that will be invoked with the result of the
  /// onRegionEntered event. It will provide [NotificareRegion] representing the
  /// region the user has entered.
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

  /// Sets a callback that will be invoked when an onRegionExited event is
  /// triggered in the background.
  ///
  /// - `onRegionExit`: A callback that will be invoked with the result of the
  /// onRegionExited event. It will provide the [NotificareRegion] representing
  /// the region the user has exited.
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

  /// Sets a callback that will be invoked when an onBeaconEntered event is
  /// triggered in the background.
  ///
  /// - `onBeaconsEntered` A callback that will be invoked with the result of the
  /// onBeaconEntered event. It will provide the [NotificareBeacon] representing
  /// the beacon the user has entered the proximity of.
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

  /// Sets a callback that will be invoked when an onBeaconExited event is
  /// triggered in the background.
  ///
  /// - `onBeaconExited`: A callback that will be invoked with the result of the
  /// onBeaconExited event. It will provide the [NotificareBeacon]
  /// representing the beacon the user has exited the proximity of.
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

  /// Sets a callback that will be invoked when an onBeaconsRanged event is
  /// triggered in the background.
  ///
  /// - `event`: A callback that will be invoked with the result of the
  /// onBeaconsRanged event. It will provide a [NotificareRangedBeaconsEvent]
  /// containing a list of [NotificareBeacon] that were detected and the
  /// [NotificareRegion] where they were detected.
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

  /// Called when a new location update is received.
  ///
  /// It will provide the updated [NotificareLocation] object representing the
  /// user's new location.
  static Stream<NotificareLocation> get onLocationUpdated {
    return _getEventStream('location_updated').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareLocation.fromJson(json.cast());
    });
  }

  /// Called when the user enters a monitored region.
  ///
  /// It will provide the [NotificareRegion] representing the region the user has
  /// entered.
  static Stream<NotificareRegion> get onRegionEntered {
    return _getEventStream('region_entered').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareRegion.fromJson(json.cast());
    });
  }

  /// Called when the user exits a monitored region.
  ///
  /// It will provide the [NotificareRegion] representing the region the user has
  /// exited.
  static Stream<NotificareRegion> get onRegionExited {
    return _getEventStream('region_exited').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareRegion.fromJson(json.cast());
    });
  }

  /// Called when the user enters the proximity of a beacon.
  ///
  /// It will provide the [NotificareBeacon] representing the beacon the user has
  /// entered the proximity of.
  static Stream<NotificareBeacon> get onBeaconEntered {
    return _getEventStream('beacon_entered').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareBeacon.fromJson(json.cast());
    });
  }

  /// Called when the user exits the proximity of a beacon.
  ///
  /// It will provide the [NotificareBeacon] representing the beacon the user 
  /// has exited the proximity of.
  static Stream<NotificareBeacon> get onBeaconExited {
    return _getEventStream('beacon_exited').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareBeacon.fromJson(json.cast());
    });
  }

  /// Called when beacons are ranged in a monitored region.
  ///
  /// This method provides the list of beacons currently detected within the given
  /// region.
  ///
  /// It will provide a [NotificareRangedBeaconsEvent] containing a list of
  /// [NotificareBeacon] that were detected and the [NotificareRegion] where they
  /// were detected.
  static Stream<NotificareRangedBeaconsEvent> get onBeaconsRanged {
    return _getEventStream('beacons_ranged').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareRangedBeaconsEvent.fromJson(json.cast());
    });
  }

  /// Called when the device registers a location visit.
  ///
  /// **Note**: This method is only supported on iOS.
  ///
  /// It will provide a [NotificareVisit] object representing the details of the
  /// visit.
  static Stream<NotificareVisit> get onVisit {
    return _getEventStream('visit').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareVisit.fromJson(json.cast());
    });
  }

  /// Called when there is an update to the device’s heading.
  ///
  /// **Note**: This method is only supported on iOS.
  ///
  /// It will provide a [NotificareHeading] object containing the details of the
  /// updated heading.
  static Stream<NotificareHeading> get onHeadingUpdated {
    return _getEventStream('heading_updated').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareHeading.fromJson(json.cast());
    });
  }
}
