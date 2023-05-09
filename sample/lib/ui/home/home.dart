import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare_geo/notificare_geo.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample/ui/home/views/device_card_view.dart';
import 'package:sample/ui/home/views/dnd_card_view.dart';
import 'package:sample/ui/home/views/geo_card_view.dart';
import 'package:sample/ui/home/views/iam_card_view.dart';
import 'package:sample/ui/home/views/launch_flow_card_view.dart';
import 'package:sample/ui/home/views/other_features_card_view.dart';
import 'package:sample/ui/home/views/remote_notifications_card_view.dart';

import 'dart:io' show Platform;

class HomeView extends StatefulWidget {
  final ValueNotifier<bool> isReady;
  final ValueNotifier<bool> allowedUi;
  final int inboxBadge;

  const HomeView({super.key, required this.isReady, required this.allowedUi, required this.inboxBadge});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  bool _hasNotificationsEnabled = false;
  bool _hasLocationEnabled = false;

  bool _hasOpenedNotificationsSettings = false;
  bool _hasOpenedLocationSettings = false;

  @override
  void initState() {
    super.initState();

    widget.isReady.addListener(_onReady);
    widget.allowedUi.addListener(_onNotificationSettingsChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.allowedUi.removeListener(_onNotificationSettingsChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSettingsChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sample"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaunchFlowCardView(isReady: widget.isReady.value),
            const DeviceCardViewView(),
            RemoteNotificationsCardView(
              hasNotificationsEnabled: _hasNotificationsEnabled,
              updateNotificationsSettings: _updateNotificationsSettings,
              inboxBadge: widget.inboxBadge,
            ),
            const DoNotDisturbCardView(),
            GeoCardView(hasLocationEnabled: _hasLocationEnabled, updateLocationSettings: _updateLocationSettings),
            const InAppMessagingCardView(),
            const OtherFeaturesCardViewView(),
          ],
        ),
      ),
    );
  }

  void _onReady() {
    WidgetsBinding.instance.addObserver(this);

    _checkNotificationsEnabled();
    _checkLocationEnabled();

    widget.isReady.removeListener(_onReady);
  }

  void _onNotificationSettingsChanged() {
    _checkNotificationsEnabled();
  }

  // Check initial status

  void _checkNotificationsEnabled() async {
    try {
      final enabled = await NotificarePush.hasRemoteNotificationsEnabled && await NotificarePush.allowedUI;

      setState(() {
        _hasNotificationsEnabled = enabled;
      });
    } catch (error) {
      Logger().e('Get Notifications status error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _checkLocationEnabled() async {
    try {
      final enabled = await NotificareGeo.hasLocationServicesEnabled && await Permission.locationWhenInUse.isGranted;
      setState(() {
        _hasLocationEnabled = enabled;
      });
    } catch (error) {
      Logger().e('Get location status error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _updateNotificationsSettings(bool checked) async {
    Logger().i((checked ? "Enable" : "Disable") + " remote notifications clicked.");
    setState(() {
      _hasNotificationsEnabled = checked;
    });

    if (!checked) {
      try {
        await NotificarePush.disableRemoteNotifications();

        Logger().i('Disabled remote notifications successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disabled remote notifications successfully.'),
          ),
        );
      } catch (error) {
        Logger().e('Disable remote notifications error.', error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$error'),
            backgroundColor: Colors.red.shade900,
          ),
        );
      }

      return;
    }

    try {
      if (await _ensureNotificationsPermission()) {
        await NotificarePush.enableRemoteNotifications();

        Logger().i('Enabled remote notifications successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enabled remote notifications successfully.'),
          ),
        );
        return;
      }
    } catch (error) {
      Logger().e('Enable remote notifications error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }

    setState(() {
      _hasNotificationsEnabled = false;
    });
  }

  void _updateLocationSettings(bool checked) async {
    Logger().i((checked ? "Enable" : "Disable") + " location updates clicked.");

    setState(() {
      _hasLocationEnabled = checked;
    });

    if (!checked) {
      try {
        await NotificareGeo.disableLocationUpdates();

        Logger().i('Disabled location updates successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disabled location updates successfully.'),
          ),
        );
      } catch (error) {
        Logger().e('Disable location updates error.', error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$error'),
            backgroundColor: Colors.red.shade900,
          ),
        );
      }

      return;
    }

    try {
      if (await _ensureForegroundLocationPermission()) {
        await NotificareGeo.enableLocationUpdates();

        Logger().i('Enabled foreground location updates successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enabled foreground location updates successfully.'),
          ),
        );
      } else {
        setState(() {
          _hasLocationEnabled = false;
        });

        return;
      }
    } catch (error) {
      Logger().e('Enable foreground Location updates error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }

    try {
      if (await _ensureBackgroundLocationPermission()) {
        await _ensureBluetoothScanPermission();
        await NotificareGeo.enableLocationUpdates();

        Logger().i('Enabled background location updates successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enabled background location updates successfully.'),
          ),
        );
      }
    } catch (error) {
      Logger().e('Enable background Location updates error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  // Permissions

  void _checkSettingsChanges() async {
    if (_hasOpenedNotificationsSettings) {
      _hasOpenedNotificationsSettings = false;

      if (!await Permission.notification.isGranted) {
        return;
      }

      _updateNotificationsSettings(true);
    }

    if (_hasOpenedLocationSettings) {
      _hasOpenedLocationSettings = false;

      if (!await Permission.locationWhenInUse.isGranted) {
        if (_hasLocationEnabled) {
          setState(() {
            _hasLocationEnabled = false;
          });
        }

        return;
      }

      if (!_hasLocationEnabled) {
        _updateLocationSettings(true);
      }

      return;
    }

    if (await Permission.locationWhenInUse.isGranted != _hasLocationEnabled) {
      _checkLocationEnabled();
    }
  }

  Future<bool> _ensureNotificationsPermission() async {
    const permission = Permission.notification;
    if (await permission.isGranted) return true;

    if (await permission.isPermanentlyDenied) {
      await _handleOpenSettings(permission);

      return false;
    }

    if (await permission.shouldShowRequestRationale) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sample"),
            content: const Text("Allow notifications in order to receive relevant content."),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );

      return await permission.request().isGranted;
    }

    final granted = await permission.request().isGranted;

    if (Platform.isAndroid) {
      if (!granted && !await permission.shouldShowRequestRationale) {
        await _handleOpenSettings(permission);

        return false;
      }
    }

    return granted;
  }

  Future<bool> _ensureForegroundLocationPermission() async {
    const permission = Permission.locationWhenInUse;
    if (await permission.isGranted) return true;

    if (await permission.isPermanentlyDenied) {
      await _handleOpenSettings(permission);

      return false;
    }

    if (await permission.shouldShowRequestRationale) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sample"),
            content: const Text("We need access to foreground location in order to show relevant content."),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );

      return await permission.request().isGranted;
    }

    final granted = await permission.request().isGranted;

    if (Platform.isAndroid) {
      if (!granted && !await permission.shouldShowRequestRationale) {
        await _handleOpenSettings(permission);

        return false;
      }
    }

    return granted;
  }

  Future<bool> _ensureBackgroundLocationPermission() async {
    const permission = Permission.locationAlways;
    if (await permission.isGranted) return true;

    if (await permission.shouldShowRequestRationale) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sample"),
            content: const Text("We need access to background location in order to show relevant content."),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );

      return await permission.request().isGranted;
    }

    final granted = await permission.request().isGranted;

    return granted;
  }

  Future<bool> _ensureBluetoothScanPermission() async {
    const permission = Permission.bluetoothScan;
    if (await permission.isGranted) return true;

    if (await permission.isPermanentlyDenied) {
      return false;
    }

    if (await permission.shouldShowRequestRationale) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sample"),
            content: const Text("We need access to bluetooth in order to show relevant content."),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );

      return await permission.request().isGranted;
    }

    final granted = await permission.request().isGranted;

    return granted;
  }

  // Open Settings

  Future<void> _handleOpenSettings(Permission permission) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sample"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text((() {
                  if (permission == Permission.notification) {
                    return "Allow notifications in order to receive relevant content.";
                  }

                  if (permission == Permission.locationWhenInUse || permission == Permission.location) {
                    return "We need access to location in order to show relevant content.";
                  }

                  if (permission == Permission.locationAlways) {
                    return "We need access to background location in order to show relevant content.";
                  }

                  return "We need permission in order to show you relevant content.";
                })()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text("Settings"),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
                if (permission == Permission.notification) {
                  _hasOpenedNotificationsSettings = true;
                }
                if (permission == Permission.locationWhenInUse) {
                  _hasOpenedLocationSettings = true;
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
