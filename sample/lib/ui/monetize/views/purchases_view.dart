import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare_monetize/notificare_monetize.dart';

import 'monetize_data_field_view.dart';

class PurchasesView extends StatefulWidget {
  const PurchasesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PurchasesViewState();
}

class _PurchasesViewState extends State<PurchasesView> {
  List<NotificarePurchase> _purchases = <NotificarePurchase>[];

  @override
  void initState() {
    super.initState();

    _getPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return _purchases.isEmpty
        ? const Center(
            child: Text("No purchases found"),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _purchases.length,
              itemBuilder: (context, i) {
                var purchase = _purchases[i];
                return Card(
                  elevation: 1,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Column(
                      children: [
                        MonetizeDataFieldView(dataKey: "ID", dataValue: purchase.id),
                        const Divider(height: 0),
                        MonetizeDataFieldView(dataKey: "Identifier", dataValue: purchase.productIdentifier),
                        const Divider(height: 0),
                        MonetizeDataFieldView(dataKey: "Time", dataValue: purchase.time.toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  void _getPurchases() async {
    try {
      Logger().i('Getting purchases.');
      final purchases = await NotificareMonetize.purchases;

      setState(() {
        _purchases = purchases;
      });

      Logger().i('Got purchases successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Got purchases successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Getting purchases failed.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
