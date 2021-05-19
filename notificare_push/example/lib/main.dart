import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push/notificare_push.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    NotificarePush.setPresentationOptions(['banner', 'badge', 'sound'])
        .then((value) => print('Presentation options updated.'))
        .catchError((error) => print('Failed to update presentation options: $error'));

    Notificare.setUseAdvancedLogging(true);
    Notificare.launch();

    NotificarePush.onNotificationReceived.listen((notification) {
      print('====== Notification received ======');
      print('${notification.toJson()}');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Notification received = ${notification.message}'),
        ),
      );
    });

    NotificarePush.onSystemNotificationReceived.listen((notification) {
      print('====== System notification received ======');
      print('${notification.toJson()}');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('${notification.toJson()}'),
        ),
      );
    });

    NotificarePush.onUnknownNotificationReceived.listen((notification) {
      print('====== Unknown notification received ======');
      print('$notification');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$notification'),
        ),
      );
    });

    NotificarePush.onNotificationSettingsChanged?.listen((granted) {
      print('====== Notification settings changed ======');
      print('$granted');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Notification settings = $granted'),
        ),
      );
    });

    NotificarePush.onShouldOpenNotificationSettings?.listen((notification) {
      print('====== Should open notification settings ======');
      print('${notification?.toJson()}');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Should open notification settings'),
        ),
      );
    });

    NotificarePush.onFailedToRegisterForRemoteNotifications?.listen((error) {
      print('====== Failed to register for remote notification ======');
      print('$error');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('APNS registration error = $error'),
        ),
      );
    });

    NotificarePush.onNotificationOpened.listen((notification) {
      print('====== Notification opened ======');
      print('${notification.toJson()}');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Notification opened = ${notification.message}'),
        ),
      );
    });

    NotificarePush.onNotificationActionOpened.listen((event) {
      print('====== Notification action opened ======');
      print('${event.notification.toJson()}');
      print('${event.action.toJson()}');

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Notification = ${event.notification.message}\nAction = ${event.action.label}'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            TextButton(child: Text('Check remote notifications enabled'), onPressed: _checkRemoteNotificationsEnabled),
            TextButton(child: Text('Enable remote notifications'), onPressed: _enableRemoteNotifications),
            TextButton(child: Text('Disable remote notifications'), onPressed: _disableRemoteNotifications),
          ],
        ),
      ),
    );
  }

  void _checkRemoteNotificationsEnabled() async {
    final enabled = await NotificarePush.isRemoteNotificationsEnabled;

    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Enabled = $enabled'),
      ),
    );
  }

  void _enableRemoteNotifications() async {
    await NotificarePush.enableRemoteNotifications();
  }

  void _disableRemoteNotifications() async {
    await NotificarePush.disableRemoteNotifications();
  }
}
