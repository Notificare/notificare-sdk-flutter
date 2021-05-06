import 'package:flutter/material.dart';

import 'package:notificare/notificare.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Notificare.setUseAdvancedLogging(true);
    Notificare.launch();

    Notificare.onReady.listen((event) {
      NotificarePush.enableRemoteNotifications();
    });

    Notificare.onDeviceRegistered.listen((device) {
      print('=== ${device.id} ===');
    });

    NotificarePush.onNotificationOpened.listen((notification) {
      NotificarePushUI.presentNotification(notification)
          .then((value) => print('Notification presented.'))
          .catchError((error) => print('Failed to present notification: $error'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running'),
        ),
      ),
    );
  }
}
