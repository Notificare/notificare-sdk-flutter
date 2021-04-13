import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notificare/models/notificare_do_not_disturb.dart';
import 'package:notificare/models/notificare_time.dart';
import 'package:notificare/notificare.dart';

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
        body: ListView(
          children: [
            TextButton(
              child: const Text('Register with user'),
              onPressed: _register,
            ),
            TextButton(
              child: const Text('Register anonymous'),
              onPressed: _registerAnonymous,
            ),
            TextButton(
              child: const Text('Get current device'),
              onPressed: _getCurrentDevice,
            ),
            TextButton(
              child: const Text('Fetch tags'),
              onPressed: _fetchTags,
            ),
            TextButton(
              child: const Text('Add tags'),
              onPressed: _addTags,
            ),
            TextButton(
              child: const Text('Remove tag'),
              onPressed: _removeTag,
            ),
            TextButton(
              child: const Text('Clear tags'),
              onPressed: _clearTags,
            ),
            TextButton(
              child: const Text('Fetch DnD'),
              onPressed: _fetchDoNotDisturb,
            ),
            TextButton(
              child: const Text('Update DnD'),
              onPressed: _updateDoNotDisturb,
            ),
            TextButton(
              child: const Text('Clear DnD'),
              onPressed: _clearDoNotDisturb,
            ),
            TextButton(
              child: const Text('Get preferred language'),
              onPressed: _getPreferredLanguage,
            ),
            TextButton(
              child: const Text('Update preferred language'),
              onPressed: _updatePreferredLanguage,
            ),
            TextButton(
              child: const Text('Clear preferred language'),
              onPressed: _clearPreferredLanguage,
            ),
            TextButton(
              child: const Text('Get user data'),
              onPressed: _getUserData,
            ),
            TextButton(child: const Text('Update user data'), onPressed: _updateUserData),
            TextButton(child: const Text('Clear user data'), onPressed: _clearUserData),
          ],
        ),
      ),
    );
  }

  void _register() {
    Notificare.deviceManager
        .register('123', 'Helder Pinhal')
        .then((value) => print('Done.'))
        .catchError((err) => print('$err'));
  }

  void _registerAnonymous() {
    Notificare.deviceManager.register(null, null).then((value) => print('Done.')).catchError((err) => print('$err'));
  }

  void _getCurrentDevice() {
    Notificare.deviceManager.currentDevice
        .then((value) => print('Current device: ${value.toJson()}'))
        .catchError((err) => print('$err'));
  }

  void _fetchTags() {
    Notificare.deviceManager.fetchTags().then((value) => print('$value')).catchError((err) => print('$err'));
  }

  void _addTags() {
    Notificare.deviceManager
        .addTags(['hpinhal', 'flutter', 'remove-me'])
        .then((value) => print('Done.'))
        .catchError((err) => print('$err'));
  }

  void _removeTag() {
    Notificare.deviceManager.removeTag('remove-me').then((value) => print('Done.')).catchError((err) => print('$err'));
  }

  void _clearTags() {
    Notificare.deviceManager.clearTags().then((value) => print('Done.')).catchError((err) => print('$err'));
  }

  void _fetchDoNotDisturb() {
    Notificare.deviceManager
        .fetchDoNotDisturb()
        .then((value) => print('DnD: ${value == null ? 'null' : value.toJson()}'))
        .catchError((err) => print('Failed to fetch DnD: $err'));
  }

  void _updateDoNotDisturb() {
    final dnd = NotificareDoNotDisturb(
      start: NotificareTime.fromString('08:00'),
      end: NotificareTime.fromString('10:00'),
    );

    Notificare.deviceManager
        .updateDoNotDisturb(dnd)
        .then((value) => print('Updated DnD.'))
        .catchError((err) => print('Failed to update DnD: $err'));
  }

  void _clearDoNotDisturb() {
    Notificare.deviceManager
        .clearDoNotDisturb()
        .then((value) => print('Cleared DnD.'))
        .catchError((err) => print('Failed to clear DnD: $err'));
  }

  void _getPreferredLanguage() {
    Notificare.deviceManager.preferredLanguage
        .then((value) => print('Preferred language: $value'))
        .catchError((err) => print('Failed to update preferred language: $err'));
  }

  void _updatePreferredLanguage() {
    Notificare.deviceManager
        .updatePreferredLanguage('nl-NL')
        .then((value) => print('Updated preferred language.'))
        .catchError((err) => print('Failed to update preferred language: $err'));
  }

  void _clearPreferredLanguage() {
    Notificare.deviceManager
        .updatePreferredLanguage(null)
        .then((value) => print('Cleared preferred language.'))
        .catchError((err) => print('Failed to clear preferred language: $err'));
  }

  void _getUserData() {
    Notificare.deviceManager
        .fetchUserData()
        .then((value) => print('User data: ${value == null ? 'null' : value}'))
        .catchError((err) => print('Failed to get user data: $err'));
  }

  void _updateUserData() {
    Notificare.deviceManager
        .updateUserData({'firstName': 'Helder'})
        .then((value) => print('Done.'))
        .catchError((err) => print('Failed to update user data: $err'));
  }

  void _clearUserData() {
    Notificare.deviceManager
        .updateUserData({})
        .then((value) => print('Done.'))
        .catchError((err) => print('Failed to clear user data: $err'));
  }
}
