import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class AssetDataFieldView extends StatelessWidget {
  final String dataKey;
  final String dataValue;

  const AssetDataFieldView({
    super.key,
    required this.dataKey,
    required this.dataValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          Text(dataKey),
          const Spacer(),
          Text(
            dataValue,
            style: AppTheme.secondaryText,
          )
        ],
      ),
    );
  }
}
