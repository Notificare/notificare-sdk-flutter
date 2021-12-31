import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notificare_geo/notificare_geo.dart';
import 'package:sample/ui/views/beacon_row.dart';

class BeaconsPage extends StatefulWidget {
  const BeaconsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BeaconsPageState();
}

class _BeaconsPageState extends State<BeaconsPage> {
  NotificareRegion? _region;
  List<NotificareBeacon> _beacons = [];

  StreamSubscription? _rangedBeaconsSubscription;

  @override
  void initState() {
    super.initState();

    _rangedBeaconsSubscription = NotificareGeo.onBeaconsRanged.listen((event) {
      setState(() {
        _region = event.region;
        _beacons = event.beacons;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _rangedBeaconsSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacons'),
      ),
      body: ListView.builder(
        itemCount: _beacons.length + (_region != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _region!.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            );
          }

          return BeaconRow(beacon: _beacons[index - 1]);
        },
      ),
    );
  }
}
