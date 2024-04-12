import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notificare_geo/notificare_geo.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  const MethodChannel _backgroundChannel = MethodChannel(
    're.notifica.geo.flutter/notificare_geo_background',
    JSONMethodCodec(),
  );

  WidgetsFlutterBinding.ensureInitialized();

  _backgroundChannel.setMethodCallHandler((MethodCall call) async {
    final Map<dynamic, dynamic> arguments = call.arguments;
    final Function? callback = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(arguments.remove("callback")));

    if (callback == null) {
      return;
    }

    switch (call.method) {
      case "location_updated":
        _onLocationUpdated(arguments, callback);
        break;

      case "region_entered":
        _onRegionEntered(arguments, callback);
        break;

      case "region_exited":
        _onRegionExited(arguments, callback);
        break;

      case "beacon_entered":
        _onBeaconEntered(arguments, callback);
        break;

      case "beacon_exited":
        _onBeaconExited(arguments, callback);
        break;

      case "beacons_ranged":
        _onBeaconsRanged(arguments, callback);
        break;

      case "visit":
        _onVisit(arguments, callback);
        break;

      case "heading_updated":
        _onHeadingUpdated(arguments, callback);
        break;

      default:
        print("Method not implemented: ${call.method}");
    }
  });

  _backgroundChannel.invokeMethod('onBackgroundServiceInitialized');
}

void _onLocationUpdated(Map<dynamic, dynamic> arguments, Function callback) {
  final Map<dynamic, dynamic> json = arguments["location"];
  final NotificareLocation location = NotificareLocation.fromJson(json.cast());

  callback.call(location);
}

void _onRegionEntered(Map<dynamic, dynamic> arguments, Function callback) {
  final Map<dynamic, dynamic> json = arguments["region"];
  final NotificareRegion region = NotificareRegion.fromJson(json.cast());

  callback.call(region);
}

void _onRegionExited(Map<dynamic, dynamic> arguments, Function callback) {
  final Map<dynamic, dynamic> json = arguments["region"];
  final NotificareRegion region = NotificareRegion.fromJson(json.cast());

  callback.call(region);
}

void _onBeaconEntered(Map<dynamic, dynamic> arguments, Function callback) {
  final Map<dynamic, dynamic> json = arguments["beacon"];
  final NotificareBeacon beacon = NotificareBeacon.fromJson(json.cast());

  callback.call(beacon);
}

void _onBeaconExited(Map<dynamic, dynamic> arguments, Function callback) {
  final Map<dynamic, dynamic> json = arguments["beacon"];
  final NotificareBeacon beacon = NotificareBeacon.fromJson(json.cast());

  callback.call(beacon);
}

void _onBeaconsRanged(Map<dynamic, dynamic> arguments, Function callback) {
  final NotificareRangedBeaconsEvent event =
      NotificareRangedBeaconsEvent.fromJson(arguments.cast());

  callback.call(event);
}

void _onVisit(Map<dynamic, dynamic> arguments, Function callback) {
  final Map<dynamic, dynamic> json = arguments["visit"];
  final NotificareVisit visit = NotificareVisit.fromJson(json.cast());

  callback.call(visit);
}

void _onHeadingUpdated(Map<dynamic, dynamic> arguments, Function callback) {
  final Map<dynamic, dynamic> json = arguments["heading"];
  final NotificareHeading heading = NotificareHeading.fromJson(json.cast());

  callback.call(heading);
}
