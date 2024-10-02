import 'dart:async';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_push_ui/notificare_push_ui.dart';
import 'package:notificare_user_inbox/notificare_user_inbox.dart';

import '../../logger/logger.dart';
import '../../network/user_inbox_request.dart';
import '../../utils/enviroment_variables.dart';
import 'inbox_item.dart';

class InboxView extends StatefulWidget {
  const InboxView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  StreamSubscription<NotificareNotification>? _onNotificationOpenedSubscription;
  StreamSubscription<NotificareNotificationReceivedEvent>?
      _onNotificationReceivedSubscription;

  List<NotificareUserInboxItem> _items = [];

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();

    _initAuth0AndRefreshInbox();
    _setupListeners();
  }

  @override
  void dispose() {
    super.dispose();

    _cancelListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Inbox'),
        actions: [
          InkWell(
            onTap: _refresh,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.sync),
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

  void _initAuth0AndRefreshInbox() async {
    final env = await parseEnvVariablesToMap(assetsFileName: '.env');
    final domain = env['USER_INBOX_DOMAIN'];
    final clientId = env['USER_INBOX_CLIENT_ID'];

    auth0 = Auth0(domain!, clientId!);

    _refresh();
  }

  _setupListeners() {
    _onNotificationReceivedSubscription =
        NotificarePush.onNotificationInfoReceived.listen((event) {
      _refresh();
    });

    _onNotificationOpenedSubscription =
        NotificarePush.onNotificationOpened.listen((event) {
      _refresh();
    });
  }

  _cancelListeners() {
    _onNotificationReceivedSubscription?.cancel();
    _onNotificationOpenedSubscription?.cancel();
  }

  void _showModalBottomSheet(NotificareUserInboxItem item) {
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

  void _onOpenClicked(NotificareUserInboxItem item) async {
    try {
      logger.i('Open inbox item clicked.');
      final notification = await NotificareUserInbox.open(item);
      await NotificarePushUI.presentNotification(notification);

      logger.i('Inbox item opened and presented successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inbox item opened and presented successfully.'),
        ),
      );

      if (!item.opened) {
        _refresh();
      }
    } catch (error) {
      logger.e('Open inbox item error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onMarkAsReadClicked(NotificareUserInboxItem item) async {
    try {
      logger.i('Mark as read clicked.');
      await NotificareUserInbox.markAsRead(item);

      logger.i('Marked as read successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marked as read successfully.'),
        ),
      );

      if (!item.opened) {
        _refresh();
      }
    } catch (error) {
      logger.e('Mark as read error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRemoveClicked(NotificareUserInboxItem item) async {
    try {
      logger.i('Remove inbox item clicked.');
      await NotificareUserInbox.remove(item);

      logger.i('Removed inbox item successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed inbox item successfully.'),
        ),
      );

      _refresh();
    } catch (error) {
      logger.e('Remove inbox item error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _refresh() async {
    try {
      if (!await auth0.credentialsManager.hasValidCredentials()) {
        logger.e('Failed to refresh inbox, no valid credentials.');
        return;
      }

      final credentials = await auth0.credentialsManager.credentials();

      final requestResponse =
          await getUserInboxResponse(credentials.accessToken);

      final userInboxResponse =
          await NotificareUserInbox.parseResponseFromString(requestResponse);

      setState(() {
        _items = userInboxResponse.items;
      });

      logger.i('Successfully refreshed inbox.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully refreshed inbox.'),
        ),
      );
    } catch (error) {
      logger.e('Failed to refresh inbox.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to refresh inbox.'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
