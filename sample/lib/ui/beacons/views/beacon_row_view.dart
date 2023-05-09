import 'package:flutter/material.dart';
import 'package:notificare_geo/notificare_geo.dart';

class BeaconRowView extends StatelessWidget {
  final NotificareBeacon beacon;

  const BeaconRowView({
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
                Text(beacon.name, style: Theme.of(context).textTheme.bodyLarge),
                Text("${beacon.major}:${beacon.minor}", style: Theme.of(context).textTheme.bodyMedium),
                Text(beacon.id, style: Theme.of(context).textTheme.bodySmall),
                Text(beacon.proximity, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
