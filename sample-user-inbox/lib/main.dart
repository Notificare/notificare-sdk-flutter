import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';
import 'package:sample_user_inbox/ui/home/home.dart';

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
    // region Notificare events

    Notificare.onReady.listen((application) async {
      logger.i('Notificare onReady event.');
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Notificare: ${application.name}'),
        ),
      );
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
      logger.i(
          'Notification received (${event.deliveryMechanism}): ${event.notification.toJson()}');

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

    NotificarePush.onSubscriptionChanged.listen((subscription) {
      logger.i('Subscription changed: ${subscription?.toJson()}');

      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Subscription changed: ${subscription?.toJson()}'),
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

    try {
      await NotificarePush.setPresentationOptions(['banner', 'badge', 'sound']);
      await Notificare.launch();
    } catch (error) {
      logger.e('Something went wrong.', error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Sample User Inbox',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: const HomeView());
  }
}
