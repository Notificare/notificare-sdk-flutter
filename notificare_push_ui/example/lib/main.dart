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
    NotificarePush.setPresentationOptions(['alert', 'badge', 'sound']);
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

    NotificarePushUI.onNotificationWillPresent.listen((notification) {
      print('---> notification will present');
    });

    NotificarePushUI.onNotificationPresented.listen((notification) {
      print('---> notification presented');
    });

    NotificarePushUI.onNotificationFinishedPresenting.listen((notification) {
      print('---> notification finished presenting');
    });

    NotificarePushUI.onNotificationFailedToPresent.listen((notification) {
      print('---> notification failed to present');
    });

    NotificarePushUI.onNotificationUrlClicked.listen((data) {
      print('---> notification url clicked');
    });

    NotificarePushUI.onActionWillExecute.listen((data) {
      print('---> action will execute');
    });

    NotificarePushUI.onActionExecuted.listen((data) {
      print('---> action executed');
    });

    NotificarePushUI.onActionNotExecuted.listen((data) {
      print('---> action not executed');
    });

    NotificarePushUI.onActionFailedToExecute.listen((data) {
      print('---> action failed to execute');
    });

    NotificarePushUI.onCustomActionReceived.listen((data) {
      print('---> custom action received');
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
