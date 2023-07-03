import 'package:flutter/material.dart';
import 'package:notificare_assets/notificare_assets.dart';
import 'package:sample/ui/assets/views/assets_list_view.dart';

import '../../logger/logger.dart';

class AssetsView extends StatefulWidget {
  const AssetsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AssetsViewState();
}

class _AssetsViewState extends State<AssetsView> {
  final _controller = TextEditingController();
  List<NotificareAsset> _assets = <NotificareAsset>[];
  String _assetName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Assets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 0, 8),
              child: Row(
                children: [
                  Text(
                    "Search Assets".toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Card(
              elevation: 1,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                      ),
                      onChanged: _didChangeAssetName,
                    ),
                  ),
                  TextButton(
                    child: const Text("Search"),
                    onPressed: _assetName != "" ? _onFetchAssetsClicked : null,
                  ),
                ],
              ),
            ),
            AssetsListView(assets: _assets),
          ],
        ),
      ),
    );
  }

  void _didChangeAssetName(name) {
    setState(() {
      _assetName = name;
    });
  }

  void _onFetchAssetsClicked() async {
    try {
      logger.i('Fetch assets clicked.');
      final assets = await NotificareAssets.fetch(group: _assetName);

      _controller.clear();
      setState(() {
        _assets = assets;
        _assetName = "";
      });

      logger.i('Fetched assets successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fetched assets successfully.'),
        ),
      );

      for (var asset in assets) {
        logger.i(asset.toJson());
      }
    } catch (error) {
      setState(() {
        _assets = List.empty();
      });

      logger.e('Fetch assets error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
