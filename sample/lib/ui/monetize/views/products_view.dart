import 'package:flutter/material.dart';
import 'package:notificare_monetize/notificare_monetize.dart';
import 'package:sample/ui/monetize/views/monetize_data_field_view.dart';

import '../../../logger/logger.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<NotificareProduct> _products = <NotificareProduct>[];

  @override
  void initState() {
    super.initState();

    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return _products.isEmpty
        ? const Center(
            child: Text("No products found"),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _products.length,
              itemBuilder: (context, i) {
                var product = _products[i];
                final price = product.storeDetails?.price;
                return Card(
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
                            MonetizeDataFieldView(dataKey: "ID", dataValue: product.id),
                            const Divider(height: 0),
                            MonetizeDataFieldView(dataKey: "Name", dataValue: product.name),
                            const Divider(height: 0),
                            MonetizeDataFieldView(dataKey: "Type", dataValue: product.type),
                            const Divider(height: 0),
                            MonetizeDataFieldView(dataKey: "Price", dataValue: price.toString()),
                            const Divider(height: 0),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _onPurchaseProductClicked(product),
                        child: const Text("Buy"),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  void _loadProducts() async {
    try {
      logger.i('Getting products.');
      final products = await NotificareMonetize.products;

      setState(() {
        _products = products;
      });

      logger.i('Got products successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Got products successfully.'),
        ),
      );
    } catch (error) {
      logger.e('Getting products failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onPurchaseProductClicked(NotificareProduct product) async {
    try {
      logger.i('Purchase product clicked.');
      await NotificareMonetize.startPurchaseFlow(product);

      logger.i('Purchased flow started.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchased flow started.'),
        ),
      );
    } catch (error) {
      logger.e('Purchase flow failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
