import 'package:flutter/material.dart';
import 'package:notificare_assets/notificare_assets.dart';
import 'package:sample/theme/theme.dart';

import 'asset_data_field_view.dart';

class AssetView extends StatelessWidget {
  final NotificareAsset asset;

  const AssetView({
    super.key,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    final url = asset.url;
    final attachmentWidget = url != null
        ? Container(
            padding: const EdgeInsets.only(right: 12),
            child: Image.network(
              url,
              width: 96,
              height: 64,
            ),
          )
        : Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
            child: Text(
              url.toString(),
              style: AppTheme.secondaryText,
            ),
          );

    final description = asset.description;
    final key = asset.key;
    final buttonLabel = asset.button?.label;
    final buttonAction = asset.button?.action;
    final metaType = asset.metaData?.contentType;
    final metaLength = asset.metaData?.contentLength;
    final metaFileName = asset.metaData?.originalFileName;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Column(
                children: [
                  AssetDataFieldView(dataKey: "Title", dataValue: asset.title),
                  const Divider(height: 0),
                  AssetDataFieldView(
                      dataKey: "Description",
                      dataValue: description != null && description.length > 14
                          ? description.substring(0, 14) + "..."
                          : description.toString()),
                  const Divider(height: 0),
                  AssetDataFieldView(
                      dataKey: "Key",
                      dataValue:
                          key != null && key.length > 14 ? "..." + key.substring(key.length - 14) : key.toString()),
                  const Divider(height: 0),
                  Row(
                    children: [
                      const Text("Url"),
                      const Spacer(),
                      attachmentWidget,
                    ],
                  ),
                  const Divider(height: 0),
                  AssetDataFieldView(dataKey: "Button Label", dataValue: buttonLabel.toString()),
                  const Divider(height: 0),
                  AssetDataFieldView(dataKey: "Button Action", dataValue: buttonAction.toString()),
                  const Divider(height: 0),
                  AssetDataFieldView(dataKey: "Meta Content Type", dataValue: metaType.toString()),
                  const Divider(height: 0),
                  AssetDataFieldView(dataKey: "Meta Content Length", dataValue: metaLength.toString()),
                  const Divider(height: 0),
                  AssetDataFieldView(
                      dataKey: "Meta File Name",
                      dataValue: metaFileName != null && metaFileName.length > 14
                          ? "..." + metaFileName.substring(metaFileName.length - 14)
                          : metaFileName.toString())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
