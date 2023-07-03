import 'package:flutter/material.dart';
import 'package:sample/ui/monetize/views/products_view.dart';
import 'package:sample/ui/monetize/views/purchases_view.dart';

class MonetizeView extends StatefulWidget {
  const MonetizeView({super.key});

  @override
  State<MonetizeView> createState() => _MonetizeViewState();
}

class _MonetizeViewState extends State<MonetizeView> {
  int _selectedIndex = 0;

  static const List _tabViews = [
    ProductsView(),
    PurchasesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Monetize'),
      ),
      body: _tabViews[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Purchases',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
