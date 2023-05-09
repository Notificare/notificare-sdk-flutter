import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class DeviceDataFieldView extends StatefulWidget {
  final String dataKey;
  final String dataValue;

  const DeviceDataFieldView({
    super.key,
    required this.dataKey,
    required this.dataValue,
  });

  @override
  State<StatefulWidget> createState() => _DeviceDataFieldViewState();
}

class _DeviceDataFieldViewState extends State<DeviceDataFieldView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          Text(widget.dataKey),
          const Spacer(),
          Text(
            widget.dataValue,
            style: App.secondaryText,
          )
        ],
      ),
    );
  }
}
