import 'package:flutter/material.dart';
import 'package:notificare_assets/notificare_assets.dart';

import 'asset_view.dart';

class AssetsListView extends StatelessWidget {
  final List<NotificareAsset> assets;

  const AssetsListView({
    super.key,
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    return assets.isEmpty
        ? Container()
        : Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: assets.length,
              itemBuilder: (context, i) {
                final asset = assets[i];
                return AssetView(asset: asset);
              },
            ),
          );
  }
}
