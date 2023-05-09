import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare_geo/notificare_geo.dart';

import '../../../main.dart';
import '../../beacons/beacons.dart';

class GeoCardView extends StatefulWidget {
  final bool hasLocationEnabled;
  final Function(bool checked) updateLocationSettings;

  const GeoCardView({
    super.key,
    required this.hasLocationEnabled,
    required this.updateLocationSettings,
  });

  @override
  GeoCardViewState createState() => GeoCardViewState();
}

class GeoCardViewState extends State<GeoCardView> {
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
                onPressed: () => _geoInfo(),
                icon: const Icon(
                  Icons.info,
                ),
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
                    const SizedBox(
                      width: 12,
                    ),
                    Text("Location Services", style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: App.primaryBlue,
                      value: widget.hasLocationEnabled,
                      onChanged: widget.updateLocationSettings,
                    ),
                  ],
                ),
              ),
              Container(margin: const EdgeInsets.fromLTRB(48, 0, 0, 0), child: const Divider(height: 0)),
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
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Beacons", style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
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

  Future<void> _geoInfo() async {
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
      Logger().e('Geo info error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
