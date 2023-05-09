import 'package:flutter/material.dart';

import '../../../main.dart';

class AssetDataFieldView extends StatefulWidget {
  final String dataKey;
  final String dataValue;

  const AssetDataFieldView({
    super.key,
    required this.dataKey,
    required this.dataValue,
  });

  @override
  State<StatefulWidget> createState() => _AssetDataFieldViewState();
}

class _AssetDataFieldViewState extends State<AssetDataFieldView> {
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
