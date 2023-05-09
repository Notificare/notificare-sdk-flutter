import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare_inbox/notificare_inbox.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';

import 'inbox_item.dart';

class InboxView extends StatefulWidget {
  const InboxView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  late StreamSubscription<List<NotificareInboxItem>> _inboxItemsStream;

  List<NotificareInboxItem> _items = [];

  @override
  void initState() {
    super.initState();

    _loadInboxItems();
    _observeItems();
  }

  @override
  dispose() {
    super.dispose();

    _inboxItemsStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Inbox'),
        actions: [
          InkWell(
            onTap: _onRefreshClicked,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.sync),
            ),
          ),
          InkWell(
            onTap: _onMarkAllAsReadClicked,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.mark_email_read),
            ),
          ),
          InkWell(
            onTap: _onClearClicked,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.delete_sweep),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          return InkWell(
            onTap: () => _onOpenClicked(item),
            onLongPress: () => _showModalBottomSheet(item),
            child: InboxItemView(item: item),
          );
        },
      ),
    );
  }

  void _showModalBottomSheet(NotificareInboxItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Open"),
              onTap: () {
                _onOpenClicked(item);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: const Text("Mark as Read"),
              onTap: () {
                _onMarkAsReadClicked(item);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              onTap: () {
                _onRemoveClicked(item);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _loadInboxItems() async {
    try {
      final loadedItems = await NotificareInbox.items;

      setState(() {
        _items = loadedItems;
      });
    } catch (error) {
      Logger().e('Failed to load initial inbox items.', error);
    }
  }

  void _observeItems() {
    _inboxItemsStream = NotificareInbox.onInboxUpdated.listen((observedItems) {
      setState(() {
        _items = observedItems;
      });
    });
  }

  void _onOpenClicked(NotificareInboxItem item) async {
    try {
      Logger().i('Open inbox item clicked.');
      final notification = await NotificareInbox.open(item);
      await NotificarePushUI.presentNotification(notification);

      Logger().i('Inbox item opened and presented successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inbox item opened and presented successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Open inbox item error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onMarkAsReadClicked(NotificareInboxItem item) async {
    try {
      Logger().i('Mark as read clicked.');
      await NotificareInbox.markAsRead(item);

      Logger().i('Marked as read successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marked as read successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Mark as read error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRemoveClicked(NotificareInboxItem item) async {
    try {
      Logger().i('Remove inbox item clicked.');
      await NotificareInbox.remove(item);

      Logger().i('Removed inbox item successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed inbox item successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Remove inbox item error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRefreshClicked() async {
    try {
      Logger().i('Refresh inbox clicked.');
      await NotificareInbox.refresh();

      Logger().i('Refreshed inbox successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Refreshed inbox successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Refresh inbox error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onMarkAllAsReadClicked() async {
    try {
      Logger().i('Mark all as read clicked.');
      await NotificareInbox.markAllAsRead();

      Logger().i('Marked all as read successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marked all as read successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Mark all as read error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onClearClicked() async {
    try {
      Logger().i('Clear inbox clicked.');
      await NotificareInbox.clear();

      Logger().i('Cleared inbox successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cleared inbox successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Clear inbox error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
