import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notificare_geo/notificare_geo.dart';

import 'views/beacon_row_view.dart';

class BeaconsView extends StatefulWidget {
  const BeaconsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BeaconsViewState();
}

class _BeaconsViewState extends State<BeaconsView> {
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
        centerTitle: true,
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return BeaconRowView(beacon: _beacons[index - 1]);
        },
      ),
    );
  }
}
