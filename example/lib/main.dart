import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notificare/models/notificare_do_not_disturb.dart';
import 'package:notificare/models/notificare_time.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_example/home.dart';

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
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Notificare.onReady.listen((event) => print('Notificare is ready.'));

    Notificare.onDeviceRegistered.listen((device) => print('Device registered: ${device.toJson()}'));

    try {
      await Notificare.launch();
    } on Exception {
      print('Failed to launch Notificare.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Home(),
      ),
    );
  }
}
