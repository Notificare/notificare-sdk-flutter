import 'package:flutter/material.dart';
import 'package:notificare_inbox/models/notificare_inbox_item.dart';
import 'package:notificare_inbox/notificare_inbox.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';
import 'package:sample/ui/views/inbox_item.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<NotificareInboxItem> _items = [];

  @override
  void initState() {
    super.initState();

    NotificareInbox.items.then((items) {
      setState(() {
        _items = items;
      });
    }).catchError((error) {
      debugPrint('Failed to load initial inbox items. $error');
    });

    NotificareInbox.onInboxUpdated.listen((items) {
      setState(() {
        _items = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onTap: () async {
              final notification = await NotificareInbox.open(item);
              await NotificarePushUI.presentNotification(notification);
            },
            child: InboxItem(item: item),
          );
        },
      ),
    );
  }

  void _onRefreshClicked() async {
    await NotificareInbox.refresh();
  }

  void _onMarkAllAsReadClicked() async {
    await NotificareInbox.markAllAsRead();
  }

  void _onClearClicked() async {
    await NotificareInbox.clear();
  }
}
