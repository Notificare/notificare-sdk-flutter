import 'package:flutter/material.dart';
import 'package:notificare_geo/notificare_geo.dart';

class BeaconRow extends StatelessWidget {
   final NotificareBeacon beacon;

  const BeaconRow({
    Key? key,
    required this.beacon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(beacon.name, style: Theme.of(context).textTheme.bodyText1),
                Text("${beacon.major}:${beacon.minor}", style: Theme.of(context).textTheme.bodyText2),
                Text(beacon.id, style: Theme.of(context).textTheme.caption),
                Text(beacon.proximity, style: Theme.of(context).textTheme.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
