import 'package:flutter/material.dart';
import 'package:notificare/models/notificare_do_not_disturb.dart';
import 'package:notificare/models/notificare_time.dart';
import 'package:notificare/notificare.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    Notificare.onReady.listen((application) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notificare is ready: ${application.name}'),
        ),
      );
    });

    Notificare.onDeviceRegistered.listen((device) {
      print('Device registered: ${device.toJson()}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Device registered: ${device.id}'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(child: const Text('Fetch application'), onPressed: _fetchApplication),
        TextButton(child: const Text('Register with user'), onPressed: _register),
        TextButton(child: const Text('Register anonymous'), onPressed: _registerAnonymous),
        TextButton(child: const Text('Get current device'), onPressed: _getCurrentDevice),
        TextButton(child: const Text('Fetch tags'), onPressed: _fetchTags),
        TextButton(child: const Text('Add tags'), onPressed: _addTags),
        TextButton(child: const Text('Remove tag'), onPressed: _removeTag),
        TextButton(child: const Text('Clear tags'), onPressed: _clearTags),
        TextButton(child: const Text('Fetch DnD'), onPressed: _fetchDoNotDisturb),
        TextButton(child: const Text('Update DnD'), onPressed: _updateDoNotDisturb),
        TextButton(child: const Text('Clear DnD'), onPressed: _clearDoNotDisturb),
        TextButton(child: const Text('Get preferred language'), onPressed: _getPreferredLanguage),
        TextButton(child: const Text('Update preferred language'), onPressed: _updatePreferredLanguage),
        TextButton(child: const Text('Clear preferred language'), onPressed: _clearPreferredLanguage),
        TextButton(child: const Text('Get user data'), onPressed: _getUserData),
        TextButton(child: const Text('Update user data'), onPressed: _updateUserData),
        TextButton(child: const Text('Clear user data'), onPressed: _clearUserData),
        TextButton(child: const Text('Fetch notification'), onPressed: _fetchNotification),
      ],
    );
  }

  void _fetchApplication() {
    Notificare.fetchApplication().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${value.name} (${value.id})'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _register() {
    Notificare.deviceManager.register('helder@notifica.re', 'Helder Pinhal').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _registerAnonymous() {
    Notificare.deviceManager.register(null, null).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _getCurrentDevice() {
    Notificare.deviceManager.currentDevice.then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${value?.toJson()}'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _fetchTags() {
    Notificare.deviceManager.fetchTags().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$value'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _addTags() {
    Notificare.deviceManager.addTags(['hpinhal', 'flutter', 'remove-me']).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _removeTag() {
    Notificare.deviceManager.removeTag('remove-me').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _clearTags() {
    Notificare.deviceManager.clearTags().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _fetchDoNotDisturb() {
    Notificare.deviceManager.fetchDoNotDisturb().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${value?.toJson()}'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _updateDoNotDisturb() {
    final dnd = NotificareDoNotDisturb(
      start: NotificareTime.fromString('08:00'),
      end: NotificareTime.fromString('10:00'),
    );

    Notificare.deviceManager.updateDoNotDisturb(dnd).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _clearDoNotDisturb() {
    Notificare.deviceManager.clearDoNotDisturb().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _getPreferredLanguage() {
    Notificare.deviceManager.preferredLanguage.then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$value'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _updatePreferredLanguage() {
    Notificare.deviceManager.updatePreferredLanguage('nl-NL').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _clearPreferredLanguage() {
    Notificare.deviceManager.updatePreferredLanguage(null).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _getUserData() {
    Notificare.deviceManager.fetchUserData().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$value'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _updateUserData() {
    Notificare.deviceManager.updateUserData({'firstName': 'Helder'}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _clearUserData() {
    Notificare.deviceManager.updateUserData({}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done.'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }

  void _fetchNotification() {
    Notificare.fetchNotification('60801c162bfa3c6cd0198cda').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${value.toJson()}'),
        ),
      );
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    });
  }
}
