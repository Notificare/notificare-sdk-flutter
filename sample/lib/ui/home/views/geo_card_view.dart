import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notificare_geo/notificare_geo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample/theme/theme.dart';

import '../../../logger/logger.dart';
import '../../beacons/beacons.dart';

class GeoCardView extends StatefulWidget {
  const GeoCardView({
    super.key,
  });

  @override
  _GeoCardViewState createState() => _GeoCardViewState();
}

class _GeoCardViewState extends State<GeoCardView> with WidgetsBindingObserver {
  bool _hasLocationEnabled = false;
  bool _hasOpenedLocationSettings = false;

  @override
  void initState() {
    super.initState();

    _setupListeners();
    _checkLocationStatus();
  }

  @override
  void dispose() {
    super.dispose();

    _cancelListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSettingsChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Row(
            children: [
              Text(
                "Geo".toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showGeoStatusInfo(),
                icon: const Icon(Icons.info),
              ),
            ],
          ),
        ),
        Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 12),
                    Text(
                      "Location Services",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: AppTheme.primaryBlue,
                      value: _hasLocationEnabled,
                      onChanged: _updateLocationStatus,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                child: const Divider(height: 0),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BeaconsView(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.bluetooth_audio),
                      const SizedBox(width: 12),
                      Text(
                        "Beacons",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _setupListeners() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _cancelListeners() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void _checkLocationStatus() async {
    try {
      final enabled = await NotificareGeo.hasLocationServicesEnabled && await Permission.locationWhenInUse.isGranted;
      setState(() {
        _hasLocationEnabled = enabled;
      });
    } catch (error) {
      logger.e('Get location status error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _updateLocationStatus(bool checked) async {
    logger.i((checked ? "Enable" : "Disable") + " location updates clicked.");

    setState(() {
      _hasLocationEnabled = checked;
    });

    if (!checked) {
      try {
        await NotificareGeo.disableLocationUpdates();

        logger.i('Disabled location updates successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disabled location updates successfully.'),
          ),
        );
      } catch (error) {
        logger.e('Disable location updates error.', error);
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

        logger.i('Enabled foreground location updates successfully.');
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
      logger.e('Enable foreground Location updates error.', error);
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

        logger.i('Enabled background location updates successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enabled background location updates successfully.'),
          ),
        );
      }
    } catch (error) {
      logger.e('Enable background Location updates error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
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

  void _checkSettingsChanges() async {
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
        _updateLocationStatus(true);
      }

      return;
    }

    if (await Permission.locationWhenInUse.isGranted != _hasLocationEnabled) {
      _checkLocationStatus();
    }
  }

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
                _hasOpenedLocationSettings = true;
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

  Future<void> _showGeoStatusInfo() async {
    try {
      final hasLocationServiceEnabled = await NotificareGeo.hasLocationServicesEnabled;
      final hasBluetoothEnabled = await NotificareGeo.hasBluetoothEnabled;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Location Service"),
            content: Wrap(
              children: [
                Row(
                  children: [
                    const Text("Enabled: "),
                    const Spacer(),
                    Text(
                      hasLocationServiceEnabled.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Bluetooth: "),
                    const Spacer(),
                    Text(
                      hasBluetoothEnabled.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
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
    } catch (error) {
      logger.e('Geo info error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
