import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_geo/notificare_geo.dart';
import 'package:notificare_in_app_messaging/notificare_in_app_messaging.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';
import 'package:notificare_scannables/notificare_scannables.dart';
import 'package:sample/ui/home/home.dart';

import 'logger/logger.dart';

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

  @override
  void initState() {
    super.initState();

    _configureNotificare();
  }

  void _configureNotificare() async {
    try {
      await NotificarePush.setPresentationOptions(['banner', 'badge', 'sound']);
      await Notificare.launch();
    } catch (error) {
      logger.e('Something went wrong.', error);
    }

    // region Notificare events

    Notificare.onReady.listen((application) async {
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
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('allowedUI = $granted'),
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
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Location updated: ${location.toJson()}'),
        ),
      );
    });

    NotificareGeo.onRegionEntered.listen((region) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Region entered: ${region.name}'),
        ),
      );
    });

    NotificareGeo.onRegionExited.listen((region) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Region exited: ${region.name}'),
        ),
      );
    });

    NotificareGeo.onBeaconEntered.listen((beacon) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Beacon entered: ${beacon.name}'),
        ),
      );
    });

    NotificareGeo.onBeaconExited.listen((beacon) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Beacon exited: ${beacon.name}'),
        ),
      );
    });

    NotificareGeo.onVisit.listen((visit) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Visit: ${visit.toJson()}'),
        ),
      );
    });

    NotificareGeo.onHeadingUpdated.listen((heading) {
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
