import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample/theme/theme.dart';

class MonetizeDataFieldView extends StatelessWidget {
  final String dataKey;
  final String dataValue;

  const MonetizeDataFieldView({
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
