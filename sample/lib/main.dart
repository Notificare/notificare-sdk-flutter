import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_geo/notificare_geo.dart';
import 'package:notificare_in_app_messaging/notificare_in_app_messaging.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';
import 'package:notificare_scannables/notificare_scannables.dart';
import 'package:sample/ui/home/home.dart';

import 'logger/custom_event_logger.dart';
import 'logger/logger.dart';

@pragma('vm:entry-point')
Future<void> _onLocationUpdatedCallback(NotificareLocation location) async {
  logger.i('onLocationUpdatedCallback');

  logCustomEvent("onLocationUpdatedCallback", location.toJson());
}

@pragma('vm:entry-point')
Future<void> _onRegionEnteredCallback(NotificareRegion region) async {
  logger.i('onRegionEnteredCallback');

  logCustomEvent("onRegionEnteredCallback", region.toJson());
}

@pragma('vm:entry-point')
Future<void> _onRegionExitedCallback(NotificareRegion region) async {
  logger.i('onRegionExitedCallback in app side');

  logCustomEvent("onRegionExitedCallback", region.toJson());
}

@pragma('vm:entry-point')
Future<void> _onBeaconEnteredCallback(NotificareBeacon beacon) async {
  logger.i('onBeaconEnteredCallback in app side');

  logCustomEvent("onBeaconEnteredCallback", beacon.toJson());
}

@pragma('vm:entry-point')
Future<void> _onBeaconExitedCallback(NotificareBeacon beacon) async {
  logger.i('onBeaconExitedCallback in app side');

  logCustomEvent("onBeaconExitedCallback", beacon.toJson());
}

@pragma('vm:entry-point')
Future<void> _onBeaconsRangedCallback(NotificareRangedBeaconsEvent event) async {
  logger.i('onBeaconsRangedCallback in app side');

  logCustomEvent("onBeaconsRangedCallback", event.toJson());
}

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool get isIOSBackgroundEvent {
    final appState = WidgetsBinding.instance.lifecycleState;

    return Platform.isIOS && (appState == AppLifecycleState.inactive || appState == AppLifecycleState.detached);
  }

  @override
  void initState() {
    super.initState();

    _configureNotificare();
  }

  void _configureNotificare() async {
    await NotificareGeo.onLocationUpdatedCallback(_onLocationUpdatedCallback);
    await NotificareGeo.onRegionEnteredCallback(_onRegionEnteredCallback);
    await NotificareGeo.onRegionExitedCallback(_onRegionExitedCallback);
    await NotificareGeo.onBeaconEnteredCallback(_onBeaconEnteredCallback);
    await NotificareGeo.onBeaconExitedCallback(_onBeaconExitedCallback);
    await NotificareGeo.onBeaconsRangedCallback(_onBeaconsRangedCallback);

    // region Notificare events

    Notificare.onReady.listen((application) async {
      logger.i('Notificare onReady event.');
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Notificare: ${application.name}'),
        ),
      );

      _handleDeferredLink();
    });

    Notificare.onUnlaunched.listen((event) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notificare finished un-launching.'),
        ),
      );
    });

    Notificare.onDeviceRegistered.listen((device) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Device registered: ${device.id}'),
        ),
      );
    });

    Notificare.onUrlOpened.listen((url) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('URL opened: $url'),
        ),
      );
    });

    // endregion

    // region Notificare Push events

    NotificarePush.onNotificationInfoReceived.listen((event) {
      logger.i('Notification received (${event.deliveryMechanism}): ${event.notification.toJson()}');

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Notification (${event.deliveryMechanism}) received.'),
        ),
      );
    });

    NotificarePush.onSystemNotificationReceived.listen((notification) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('System notification received.'),
        ),
      );
    });

    NotificarePush.onUnknownNotificationReceived.listen((notification) {
      logger.i('Unknown notification received: $notification');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Unknown notification received.'),
        ),
      );
    });

    NotificarePush.onNotificationOpened.listen((notification) async {
      await NotificarePushUI.presentNotification(notification);
    });

    NotificarePush.onUnknownNotificationOpened.listen((notification) {
      logger.i('Unknown notification opened: $notification');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Unknown notification opened.'),
        ),
      );
    });

    NotificarePush.onNotificationActionOpened.listen((data) async {
      await NotificarePushUI.presentAction(data.notification, data.action);
    });

    NotificarePush.onUnknownNotificationActionOpened.listen((data) {
      logger.i('Unknown notification action opened: $data');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Unknown notification action opened.'),
        ),
      );
    });

    NotificarePush.onNotificationSettingsChanged.listen((granted) {
      logger.i('Notification settings changed: $granted');

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Notification settings changed: $granted'),
        ),
      );
    });

    NotificarePush.onSubscriptionIdChanged.listen((subscriptionId) {
      logger.i('Subscription ID changed: $subscriptionId');

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Subscription ID changed: $subscriptionId'),
        ),
      );
    });

    // endregion

    // region Notificare Push UI events

    NotificarePushUI.onNotificationWillPresent.listen((notification) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification will present.'),
        ),
      );
    });

    NotificarePushUI.onNotificationPresented.listen((notification) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification presented.'),
        ),
      );
    });

    NotificarePushUI.onNotificationFinishedPresenting.listen((notification) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification finished presenting.'),
        ),
      );
    });

    NotificarePushUI.onNotificationFailedToPresent.listen((notification) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification failed to present.'),
        ),
      );
    });

    NotificarePushUI.onNotificationUrlClicked.listen((data) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Notification url clicked: ${data.url}'),
        ),
      );
    });

    NotificarePushUI.onActionWillExecute.listen((data) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification action will execute.'),
        ),
      );
    });

    NotificarePushUI.onActionExecuted.listen((data) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification action executed.'),
        ),
      );
    });

    NotificarePushUI.onActionNotExecuted.listen((data) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification action not executed.'),
        ),
      );
    });

    NotificarePushUI.onActionFailedToExecute.listen((data) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification action failed to execute.'),
        ),
      );
    });

    NotificarePushUI.onCustomActionReceived.listen((data) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification custom action received.'),
        ),
      );
    });

    // endregion

    // region Notificare Geo events

    NotificareGeo.onLocationUpdated.listen((location) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onLocationUpdated", location.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Location updated: ${location.toJson()}'),
        ),
      );
    });

    NotificareGeo.onRegionEntered.listen((region) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onRegionEntered", region.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Region entered: ${region.name}'),
        ),
      );
    });

    NotificareGeo.onRegionExited.listen((region) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onRegionExited", region.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Region exited: ${region.name}'),
        ),
      );
    });

    NotificareGeo.onBeaconEntered.listen((beacon) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onBeaconEntered", beacon.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Beacon entered: ${beacon.name}'),
        ),
      );
    });

    NotificareGeo.onBeaconExited.listen((beacon) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onBeaconExited", beacon.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Beacon exited: ${beacon.name}'),
        ),
      );
    });

    NotificareGeo.onBeaconsRanged.listen((event) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onBeaconsRanged", event.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Beacons ranged: ${event.toJson()}'),
        ),
      );
    });

    NotificareGeo.onVisit.listen((visit) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onVisit", visit.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Visit: ${visit.toJson()}'),
        ),
      );
    });

    NotificareGeo.onHeadingUpdated.listen((heading) {
      if (isIOSBackgroundEvent) {
        logCustomEvent("onHeading", heading.toJson());
        return;
      }

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Heading updated: ${heading.toJson()}'),
        ),
      );
    });

    // endregion

    // region Notificare Scannable events

    NotificareScannables.onScannableDetected.listen((scannable) async {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Scannable detected: ${scannable.toJson()}'),
        ),
      );

      final notification = scannable.notification;
      if (notification != null) {
        await NotificarePushUI.presentNotification(notification);
      }
    });

    NotificareScannables.onScannableSessionFailed.listen((error) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Scannable session failed: $error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });

    // endregion

    // region Notificare In-App Messaging events

    NotificareInAppMessaging.onMessagePresented.listen((message) {
      logger.i('message presented = ${message.toJson()}');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('In-app message presented.'),
        ),
      );
    });

    NotificareInAppMessaging.onMessageFinishedPresenting.listen((message) {
      logger.i('message finished presenting = ${message.toJson()}');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('In-app message finished presenting.'),
        ),
      );
    });

    NotificareInAppMessaging.onMessageFailedToPresent.listen((message) {
      logger.i('message failed to present present = ${message.toJson()}');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('In-app message failed to present.'),
        ),
      );
    });

    NotificareInAppMessaging.onActionExecuted.listen((event) {
      logger.i('action executed = ${event.toJson()}');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('In-app message action executed.'),
        ),
      );
    });

    NotificareInAppMessaging.onActionFailedToExecute.listen((event) {
      logger.i('action failed to execute = ${event.toJson()}');

      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('In-app message action failed to execute.'),
        ),
      );
    });

    // endregion

    try {
      await NotificarePush.setPresentationOptions(['banner', 'badge', 'sound']);
      await Notificare.launch();
    } catch (error) {
      logger.e('Something went wrong.', error);
    }
  }

  void _handleDeferredLink() async {
    try {
      if (!await Notificare.canEvaluateDeferredLink) {
        return;
      }

      final evaluated = await Notificare.evaluateDeferredLink();
      logger.i('Did evaluate deferred link: $evaluated');

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Did evaluate deferred link: $evaluated'),
        ),
      );
    } catch (error) {
      logger.e('Error evaluating deferred link.', error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Sample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeView());
  }
}
