import 'package:flutter/material.dart';

import '../../device/device.dart';

class DeviceCardViewView extends StatelessWidget {
  const DeviceCardViewView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Text(
            "Device".toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        SizedBox(
          child: Card(
            elevation: 1,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeviceView(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android),
                    const SizedBox(
                      width: 12,
                    ),
                    Text("Current Device", style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
