import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_authentication/notificare_authentication.dart';
import 'package:notificare_geo/notificare_geo.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';
import 'package:notificare_scannables/notificare_scannables.dart';
import 'package:sample/ui/pages/beacons.dart';
import 'package:sample/ui/pages/home.dart';
import 'package:sample/ui/pages/inbox.dart';

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

    configureNotificare();
  }

  void configureNotificare() async {
    try {
      await NotificarePush.setPresentationOptions(['banner', 'badge', 'sound']);
      await Notificare.launch();
    } catch (error) {
      debugPrint('Something went wrong. $error');
    }

    // region Notificare events

    Notificare.onReady.listen((application) async {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Notificare: ${application.name}'),
        ),
      );

      if (await NotificarePush.hasRemoteNotificationsEnabled) {
        await NotificarePush.enableRemoteNotifications();
      }

      if (await NotificareGeo.hasLocationServicesEnabled) {
        await NotificareGeo.enableLocationUpdates();
      }
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

    NotificarePush.onNotificationReceived.listen((notification) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Notification received.'),
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
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Unknown notification received.'),
        ),
      );
    });

    NotificarePush.onNotificationOpened.listen((notification) async {
      await NotificarePushUI.presentNotification(notification);
    });

    NotificarePush.onNotificationActionOpened.listen((data) async {
      await NotificarePushUI.presentAction(data.notification, data.action);
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
        const SnackBar(
          content: Text('Notification url clicked.'),
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

    // region Notificare Authentication events

    NotificareAuthentication.onPasswordResetTokenReceived.listen((token) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Reset password token received: $token'),
        ),
      );
    });

    NotificareAuthentication.onValidateUserTokenReceived.listen((token) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Validate user token received: $token'),
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/inbox': (context) => const InboxPage(),
        '/beacons': (context) => const BeaconsPage(),
      },
    );
  }
}
