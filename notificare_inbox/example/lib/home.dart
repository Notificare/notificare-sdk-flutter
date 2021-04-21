import 'package:flutter/material.dart';
import 'package:notificare_inbox/notificare_inbox.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    NotificareInbox.onInboxUpdated.listen((items) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('[event] items = ${items.length}'),
        ),
      );
    });

    NotificareInbox.onBadgeUpdated.listen((badge) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('[event] unread = $badge'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(child: const Text('Show items'), onPressed: _showItems),
        TextButton(child: const Text('Show unread count'), onPressed: _showBadge),
      ],
    );
  }

  void _showItems() async {
    try {
      final items = await NotificareInbox.items;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Items = ${items.length}'),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _showBadge() async {
    try {
      final badge = await NotificareInbox.badge;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unread = $badge'),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$err'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
